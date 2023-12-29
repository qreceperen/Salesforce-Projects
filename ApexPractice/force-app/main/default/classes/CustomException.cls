public class CustomException extends Exception {
	// Public Runner Methods
	public override String getStackTraceString() {
		// Local Variables
		String s;

		// Initialize Local Variables
		s = '';

		//Logic
		s = new DmlException().getStackTraceString();
		while(s.substringBefore('\n').startsWithIgnoreCase('Class.CustomException.')) {
			s = s.substringAfter('\n');
		}

		return s;
	}
}