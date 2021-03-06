# Analysis of Letter Frequency

Using  **HDFS**  and  **MapReduce**  to  calculate  average  letter  frequencies  across  a number  of  languages using  the  books  that  are  available  in  Project  Gutenberg (http://www.gutenberg.org/).

### Assumptions

All files downloaded from the website Project Gutenberg and are in Plain Text UTF-8 format.

All files must be named using its language as prefix and we assume that all books from the same language must have the same prefix plus "-".

Example:

- en-book1.txt
- en-book2.txt
- it-book1.txt
- pt-book1.txt …

For this project I am using 6 books from English, Portuguese and Italian.

- [Journal of Small Things by Helen Mackay][1]
- [Il perduto amore by Umberto Fracchia][2]
- [Memorias Posthumas de Braz Cubas by Machado de Assis][3]
- [Five Little Friends by Sherred Willcox Adams][4]
- [Orlando innamorato by Matteo Maria Boiardo][5]
- [Dom Casmurro by Machado de Assis][6]

[1]: http://www.gutenberg.org/ebooks/54829
[2]: http://www.gutenberg.org/ebooks/41281
[3]: http://www.gutenberg.org/ebooks/54829
[4]: http://www.gutenberg.org/ebooks/25497
[5]: http://www.gutenberg.org/ebooks/57787
[6]: http://www.gutenberg.org/ebooks/55752
