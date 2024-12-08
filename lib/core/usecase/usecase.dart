
import 'package:fpdart/fpdart.dart';
import 'package:task_track_app/core/error/failure.dart';

abstract interface class UseCase<SuccessType,Parms>{
  Future<Either<Failure,SuccessType>> call(Parms parms);
}

class NoParms{}
//SuccessType is get from bloc and also Parms means parameter we can pass eany paramter isnide function