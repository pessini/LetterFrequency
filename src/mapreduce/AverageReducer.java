package mapreduce;

import java.io.IOException;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class AverageReducer extends Reducer<Text, DoubleWritable, Text, DoubleWritable> {
	
	/*
		INPUT example
		
		english, 7000
		english,A 300
		english,B 400
		...
		portuguese, 8000
		portuguese,A 400
		portuguese,B 500
		...
	*/
	
	double letterTotal = 0;
	double letterCount = 0;
	double averageLetterbyLanguage = 0;
	String newKey;

	public void reduce(Text key, Iterable<DoubleWritable> values, Context context)
	throws IOException, InterruptedException {

		// using the Reducer to perform this calculation to make sure that the data
		// has been sorted by shuffle/sort phase
		
		String[] languageLetter = key.toString().split(",");

		if (languageLetter.length == 1) { // total letter by language
			
			letterTotal = values.iterator().next().get();
			
		} else {
			
			letterCount = values.iterator().next().get();
			averageLetterbyLanguage = letterCount / letterTotal;
			newKey = languageLetter[0]+"\t"+languageLetter[1]; // newKey to generate tab separator for language/letter
			
			context.write(new Text(newKey), new DoubleWritable(averageLetterbyLanguage));
			
			System.out.println("key: "+newKey);
			System.out.println("Average: "+letterCount+" / "+letterTotal+" = "+averageLetterbyLanguage);
		}


	}

}
