import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:petitpotopro/features/tickets/data/datasources/user_ticket_remote_data_source.dart';
import 'package:petitpotopro/features/tickets/data/repositories/user_ticket_repository_impl.dart';
import 'package:petitpotopro/features/tickets/domain/repository/user_ticket_repository.dart';
import 'package:petitpotopro/features/tickets/domain/usecases/get_user_tickets_usecase.dart';
import 'package:petitpotopro/features/tickets/domain/usecases/purchase_ticket_usecase.dart';
import 'package:petitpotopro/features/tickets/presentation/cubit/user_tickets_cubit.dart';

void registerTicketsModule(GetIt sl) {
  sl.registerLazySingleton<UserTicketRemoteDataSource>(
    () => UserTicketRemoteDataSourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<UserTicketRepository>(
    () => UserTicketRepositoryImpl(sl<UserTicketRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetUserTicketsUseCase>(
    () => GetUserTicketsUseCase(sl<UserTicketRepository>()),
  );
  sl.registerLazySingleton<PurchaseTicketUseCase>(
    () => PurchaseTicketUseCase(sl<UserTicketRepository>()),
  );
  sl.registerFactory<UserTicketsCubit>(
    () => UserTicketsCubit(
      sl<GetUserTicketsUseCase>(),
      sl<PurchaseTicketUseCase>(),
    ),
  );
}
