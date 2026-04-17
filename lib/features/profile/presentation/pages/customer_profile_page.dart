import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n/AppLocalizations.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/domain/entities/discovery_types.dart';
import '../../../home/domain/use_cases/customer_portal_use_cases.dart';
import '../cubit/customer_profile_cubit.dart';
import '../widgets/profile_components.dart';
import '../widgets/profile_skeleton.dart';
import '../widgets/profile_view.dart';

class CustomerProfilePage extends StatelessWidget {
  const CustomerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerProfileCubit>(
      create: (context) => CustomerProfileCubit(
        getCustomerProfileUseCase: context.read<GetCustomerProfileUseCase>(),
      )..load(),
      child: const _CustomerProfileView(),
    );
  }
}

class _CustomerProfileView extends StatelessWidget {
  const _CustomerProfileView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<CustomerProfileCubit, CustomerProfileState>(
          builder: (context, state) {
            if (state.status == LoadStatus.loading ||
                state.status == LoadStatus.initial) {
              return const ProfilePageSkeleton();
            }

            if (state.status == LoadStatus.error || state.profile == null) {
              return ProfileRetryState(
                message: localizations.networkErrorServer,
                onRetry: context.read<CustomerProfileCubit>().load,
              );
            }

            final profile = state.profile!;

            return RefreshIndicator(
              color: AppColors.brandRed,
              onRefresh: context.read<CustomerProfileCubit>().load,
              child: ProfileView(
                roleLabel: localizations.profileRoleCustomer,
                onEdit: () async {
                  final updated = await context.push<bool>(
                    AppRouter.customerProfileEdit,
                  );
                  if (updated == true && context.mounted) {
                    context.read<CustomerProfileCubit>().load();
                  }
                },
                profile: ProfileViewData(
                  firstName: profile.firstName ?? '',
                  lastName: profile.lastName ?? '',
                  email: profile.email,
                  phoneNumber: profile.phoneNumber,
                  address: profile.address,
                  city: profile.city,
                  zipCode: profile.zipCode,
                  country: profile.country,
                  createdAt: profile.createdAt,
                  connectedCompanies: profile.connectedCompanies,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
