package mapreduce;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;
import java.util.regex.*;
import java.text.*;


public class LanguageLetterMapper extends Mapper<LongWritable, Text, Text, DoubleWritable> {

	String langPrefix;
	static enum MapCounters { FILES, MAP_RECORDS }
	
	/* In order to access the filename before the split in the Mapper
	 * override setup to and get the prefix created for the language
	 * This will allow the code only run once before the split.
	 * */
	
	@Override
	  protected void setup(Context context) throws IOException, InterruptedException {
	    FileSplit fileSplit = (FileSplit) context.getInputSplit();
	    String filename = fileSplit.getPath().getName();
	    String[] langPrefixFile = filename.split("-");
		langPrefix = langPrefixFile[0].toLowerCase();
		context.getCounter(MapCounters.FILES).increment(1);
	  }
	
	TextPair languageLetter = new TextPair();
	String currentLanguage;
	
	public void map(LongWritable key, Text value, Context context)
	throws IOException, InterruptedException {

		String s = value.toString();
		
		// cleaning accents
		s = Normalizer.normalize(s, Normalizer.Form.NFKD); // or NFD
		s = s.replaceAll("\\p{M}", "");
		
		// creating a Patter to match only letters CASE_INSENSITIVE
		Pattern mypattern = Pattern.compile("[a-zA-Z]+", Pattern.CASE_INSENSITIVE);

		for (char letter : s.toCharArray()) {
			
			String keyLetter = Character.toString(letter); // converts Char to String in order to pass as Text
			Matcher mymatcher = mypattern.matcher(keyLetter);
			
			if(mymatcher.matches()){
				
				// setting the letter to lower in order to unify all of them
				languageLetter.set(new Text(langPrefix), new Text(keyLetter.toLowerCase()));
				context.write(new Text(languageLetter.toString()), new DoubleWritable(1));
				
				// total letter per language
				context.write(new Text(langPrefix+","), new DoubleWritable(1));
				
				
				context.getCounter(MapCounters.MAP_RECORDS).increment(1);

			}
			
		}
		
	}

}
