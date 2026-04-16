import 'customer_offers_repository.dart';
import 'customer_requests_repository.dart';
import 'digital_signature_repository.dart';
import 'logout_repository.dart';
import 'profile_repository.dart';

abstract class CustomerPortalRepository
    implements
        ProfileRepository,
        CustomerRequestsRepository,
        CustomerOffersRepository,
        DigitalSignatureRepository,
        LogoutRepository {}
