# Analysis of Letter Frequency

Using  **HDFS**  and  **MapReduce**  to  calculate  average  letter  frequencies  across  a number  of  languages using  the  books  that  are  available  in  [Project Gutenberg](http://www.gutenberg.org/ "Project Gutenberg").

## Assumptions

All files downloaded from the website [Project Gutenberg](http://www.gutenberg.org/ "Project Gutenberg") and are in Plain Text UTF-8 format.

All files must be named using its language as prefix and we assume that all books from the same language must have the same prefix plus "-".

Example:

- en-book1.txt
- en-book2.txt
- it-book1.txt
- pt-book1.txt …

__Software version__


- JavaSE 1.7
- Hadoop Virtual Machine (VM) - Ubuntu 64-bit
- Hadoop MapReduce 2.2.0
- Oracle VirtualBox 6.1
- Eclipse IDE - Version: 2020-12 (4.18.0)

## Dataset

For this project I am using [6 books](./dataset/books/) from English, Portuguese and Italian.

- [Journal of Small Things by Helen Mackay][1]
- [Il perduto amore by Umberto Fracchia][2]
- [Memorias Posthumas de Braz Cubas by Machado de Assis][3]
- [Five Little Friends by Sherred Willcox Adams][4]
- [Orlando innamorato by Matteo Maria Boiardo][5]
- [Dom Casmurro by Machado de Assis][6]

[1]: http://www.gutenberg.org/ebooks/51245
[2]: http://www.gutenberg.org/ebooks/41281
[3]: http://www.gutenberg.org/ebooks/54829
[4]: http://www.gutenberg.org/ebooks/25497
[5]: http://www.gutenberg.org/ebooks/57787
[6]: http://www.gutenberg.org/ebooks/55752

## Loading data into HDFS

```shell
hadoop fs -mkdir /books
hadoop fs -put ./sf_VM-Shared-Folder/books/ /books
```

![alt text][Dataset]

[Dataset]: https://github.com/pessini/LetterFrequency/blob/master/img/hdfs-dataset.png "Dataset in HDFS"


## Running the program

```shell
hadoop jar sf_VM-Shared-Folder/LetterFrequency.jar books output
```

The __JAR__ file can be found [here](./JAR/).

A screenshot from the terminal with the Counters showing how many books were processed and the records processed in Mapper and Reducer:

![alt text][linux-terminal]

[linux-terminal]: https://github.com/pessini/LetterFrequency/blob/master/img/terminal-counters.png "Terminal with Counters"

---
This is the __Output file__ that was generated by the MapReduce program:

![alt text][Output]

[Output]:https://github.com/pessini/LetterFrequency/blob/master/img/output-file.png "Output file"

In order to work on the result just get the file from the HDFS making a copy to your Local Machine using this command:

```shell
hadoop fs -copyToLocal /user/soc/output/part-r-00000 ./sf_VM-Shared-Folder/frequency-letter.txt
```

## Plotting the results

Here is the final analysis comparing the 3 languages using Python ([code here](./python/letter-frequency.ipynb)):

![alt text][Languages-Plot]

[Languages-Plot]:https://github.com/pessini/LetterFrequency/blob/master/img/all-languages.png "Plotting Frequency comparison in all 3 languages"
