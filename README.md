# Analysis of Letter Frequency

Using  **HDFS**  and  **MapReduce**  to  calculate  average  letter  frequencies  across  a number  of  languages using  the  books  that  are  available  in  [Project Gutenberg](http://www.gutenberg.org/ "Project Gutenberg").

### Assumptions

All files downloaded from the website [Project Gutenberg](http://www.gutenberg.org/ "Project Gutenberg") and are in Plain Text UTF-8 format.

All files must be named using its language as prefix and we assume that all books from the same language must have the same prefix plus "-".

Example:

- en-book1.txt
- en-book2.txt
- it-book1.txt
- pt-book1.txt …

### Dataset

For this project I am using 6 books from English, Portuguese and Italian.

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

__Loading dataset into HDFS__
```shell
hadoop fs -put ./sf_VM-Shared-Folder/books/ $PATH
```

![alt text][Dataset]

[Dataset]: https://github.com/pessini/LetterFrequency/blob/master/img/hdfs-dataset.png "Dataset in HDFS"



---
This is terminal screenshot with the Counters showing how many books were processed:

![alt text][linux-terminal]

[linux-terminal]: https://github.com/pessini/LetterFrequency/blob/master/img/terminal-counters.png "Linux Terminal with Counters"
