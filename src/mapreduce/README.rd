# Algorithm Design

## Job 1

```
class Mapper
    language ← filename
	  method Map (docid a, doc d)
    for all letter L ∑ doc d do
		    Emit (language + ",", count 1)
        Emit (language + "," + letter L, count 1)

class Reducer
    method Reduce (key, counts [c1, c2, …])
		sum ← 0
		for all count c ∑ counts [c1,c2,...] do
		    sum ← sum + c
    Emit (key, count sum)
```

## Job 2

```
class Mapper
    Identity Mapper

class Reducer
    method Reduce
    letterTotal ← 0
    letterCount ← 0
    averageLetterbyLanguage ← 0

    if (first Row)
        letterTotal ← value
    else
        letterCount ← value
        averageLetterbyLanguage ← letterCount / letterTotal
        newKey ← language + " " + letter
        Emit (newKey, averageLetterbyLanguage)
```

## First Job Description

__Mapper__ -  [LanguageLetterMapper.java](./LanguageLetterMapper.java)

```java
String langPrefix;
static enum MapCounters { FILES, MAP_RECORDS }

@Override
    protected void setup(Context context)
      throws IOException, InterruptedException {
	      FileSplit fileSplit = (FileSplit) context.getInputSplit();
	      String filename = fileSplit.getPath().getName();
	      String[] langPrefixFile = filename.split("-");
		    langPrefix = langPrefixFile[0].toLowerCase();
		    context.getCounter(MapCounters.FILES).increment(1);
    }
```

In order to get the file's name before the Map split I override the setup so the code only runs 1 time per file and not for every split. I am setting a Counter as well to count all the files used on the MapReduce.

To get all letters without the accents I am using the Normalizer method which will break the letter with accents in two characters and then I just select the "clean" letter.

```java
s = Normalizer.normalize(s, Normalizer.Form.NFKD); // or NFD
s = s.replaceAll("\\p{M}", "");
```

The Pattern method will get all the letters from text.

```java
Pattern mypattern = Pattern.compile("[a-zA-Z]+", Pattern.CASE_INSENSITIVE);
```

A loop for takes place to split all the text into characters and if the character matches the Pattern it means that it's a letter and then it will be written in the context.

```java
for (char letter : s.toCharArray()) {
    String keyLetter = Character.toString(letter); // converts Char to String in order to pass as Text
	  Matcher mymatcher = mypattern.matcher(keyLetter);
    if(mymatcher.matches()){
```

I am passing the language + the letter as Key and number 1 as value. Every time the Pattern is matched it will be written the language in order to have the total letters for each language and the letter itself as shown below:

```java
// setting the letter to lower in order to unify all of them
languageLetter.set(new Text(langPrefix), new Text(keyLetter.toLowerCase()));
context.write(new Text(languageLetter.toString()), new DoubleWritable(1));
// total letter per language
context.write(new Text(langPrefix+","), new DoubleWritable(1));
```

Also it will be created a Counter to count all the Map Records.

```java
context.getCounter(MapCounters.MAP_RECORDS).increment(1);
```

__Reducer__ -  [LanguageLetterReducer.java](./LanguageLetterReducer.java)

The Reducer will Sum all the values for each key passed from the Mapper.

```java
double sum = 0;
for (DoubleWritable val : values) {
   sum += val.get();
}

context.write(key, new DoubleWritable(sum));
```

It will also increment a Counter to get the total records processed by the Reducer.

```java
context.getCounter(ReducerCounters.REDUCER_RECORDS).increment(1);
```

## Second job description

The output from the first Job is written in a Sequence File to optimize the process. The input for second Job is exemplified below:

```
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
```

__Mapper__ -  Identity Mapper

__Reducer__ -  [AverageReducer.java](./AverageReducer.java)

In the Reducer for each line from the Sequence File I will get the first row which is the sum of all letters for that language and then use it to calculate the Average as below:

```java
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
```

## Driver

The first part of the Driver class is to check if there is an existing Output directory and delete it if it is true.

```java
// Job 1
Configuration conf = new Configuration();

// delete Output Directory if exists
FileSystem fs = FileSystem.get(conf);
if(fs.exists(new Path(args[1]))) {
    fs.delete(new Path(args[1]),true);
}
```

The first job will use the reducer as a Combiner to reduce the amount of intermediate data generated by the mappers. Then it will store the data in a temp directory as a Sequence File Format.

```java
Job job1 = Job.getInstance(conf, "LangLetterSum");
job1.setJarByClass(LetterFrequency.class);

FileInputFormat.addInputPath(job1, new Path(args[0]));

job1.setMapperClass(LanguageLetterMapper.class);

// the combiner can use the same Reducer class as it does not perform any different calculations
job1.setCombinerClass(LanguageLetterReducer.class); // using reducer as combiner
job1.setReducerClass(LanguageLetterReducer.class);

job1.setOutputKeyClass(Text.class);
job1.setOutputValueClass(DoubleWritable.class);

job1.setOutputFormatClass(SequenceFileOutputFormat.class);
SequenceFileOutputFormat.setOutputPath(job1, new Path(args[0] + "/temp"));
job1.waitForCompletion(true);
```

The second job will read the Sequence file and use a Identity Mapper to pass the key/values to the Reducer. No need to implement the Mapper.

```java
// Job 2

Configuration conf2 = new Configuration();
Job job2 = Job.getInstance(conf2, "LangLetterAverage");
job2.setJarByClass(LetterFrequency.class);

FileInputFormat.addInputPath(job2, new Path(args[0] + "/temp"));
job2.setInputFormatClass(SequenceFileInputFormat.class);

// Identity Mapper - just to pass forward the key/values generated by the first job
// no need to be implemented

// passing the correct key/value class
// otherwise it will be by default LongWritable by Keys
job2.setMapOutputKeyClass(Text.class);
job2.setMapOutputValueClass(DoubleWritable.class);

job2.setReducerClass(AverageReducer.class);

job2.setOutputKeyClass(Text.class);
job2.setOutputValueClass(DoubleWritable.class);

job2.setOutputFormatClass(TextOutputFormat.class);
FileOutputFormat.setOutputPath(job2, new Path(args[1]));

job2.waitForCompletion(true);
```

The last part will call a function to clean the temporary files and print it out the counters created on the first job.

```java
// cleaning TEMP file
cleanupFile(new Path(args[0] + "/temp"));

Counter mapperCounter = job1.getCounters().findCounter(MapCounters.MAP_RECORDS);
Counter filesCounter = job1.getCounters().findCounter(MapCounters.FILES);
Counter reducerCounter = job1.getCounters().findCounter(ReducerCounters.REDUCER_RECORDS);

System.out.println("Total number of records processed in Mapper: " + mapperCounter.getValue());
System.out.println("Total files processed in MapReduce: " + filesCounter.getValue());
System.out.println("Total number of records processed in Reducer: " + reducerCounter.getValue());
```

Function to clean up the temporary files:

```java
private void cleanupFile(Path file)
{
    try {
        Configuration confFile = new Configuration();
        FileSystem fileSystem = FileSystem.get(confFile);
        if (!fileSystem.delete(file, true)) {
            fileSystem.close();
            throw new IOException("Deleting temporary files in " + file + " was unsuccessful");
        }

        fileSystem.close();
    }
    catch (IOException e) {
        System.out.println("Failed to delete temporary file: " + file);
    }
}
```
