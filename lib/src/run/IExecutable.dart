<<<<<<< HEAD
import 'dart:async';

import './Parameters.dart';

=======
/** @module run */
import './Parameters.dart';

>>>>>>> 6bfeb7c92f5e99eeea08c8f0dc4514882833fedb
/**
 * Interface for components that can be called to execute work.
 * 
 * @see [[Executor]]
 * @see [[INotifiable]]
 * @see [[Parameters]]
 * 
 * ### Example ###
 * 
 *     class EchoComponent implements IExecutable {
 *         ...
 *         public execute(correlationId: string, args: Parameters, callback: (err: any, result: any) => void): void {
 *             let result = args.getAsObject("message");
 *             callback(null, result);
 *         }
 *     }
 *     
 *     let echo = new EchoComponent();
 *     let message = "Test";
 *     echo.execute("123", Parameters.fromTuples("message", message),
 *         (err, result) => {
 *             console.log("Request: " + message + " Response: " + result);
 *         }
 *     );
 */
abstract class IExecutable {
	/**
	 * Executes component with arguments and receives execution result.
	 * 
	 * @param correlationId 	(optional) transaction id to trace execution through call chain.
	 * @param args 				execution arguments.
     * @param callback 			callback function that receives execution result or error.
	 */
<<<<<<< HEAD
	Future<dynamic> execute(String correlationId, Parameters args);
=======
	void execute(String correlationId, Parameters args, callback (dynamic err , dynamic result));
>>>>>>> 6bfeb7c92f5e99eeea08c8f0dc4514882833fedb
}
