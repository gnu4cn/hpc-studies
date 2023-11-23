# 序曲：马科夫链算法

**Interlude: Markov Chain Algorithm**


我们的下一个完整程序，是马科夫链算法的实现，Kernighan 和 Pike，在他们的书《编程实践》（Addison-Wesley，1999 年）中，对该算法进行了描述。

该程序会根据基础文本中的前 `n` 个单词序列后，可能出现的单词，生成伪随机的文本。在这个实现中，我们假设 *n* 为二。


该程序的第一部分，会读取基础文本并建立一个表，对于由两个单词组成的每个前缀，都会给出这个文本中，该前缀后面单词的列表。建立这个表后，程序就会利用他，来生成一个，其中跟随了前两个单词的单词，有着与基本文本中的相同概率。作为结果，我们得到的文本会非常随机，但又不完全随机。例如，当应用到这本书（**译注**：指英文原文）时，程序的输出结果是这样的：“*Constructors can also traverse a table constructor, then the parentheses in the following line does the whole file in a field n to store the contents of each function, but to show its only argument. If you want to find the maximum element in an array can return both the maximum value and continues showing the prompt and running the code. The following words are reserved and cannot be used to convert between degrees and radians.*”


> **译注**：关于马科夫链算法与 GPT 的区别，请参阅：[GPT vs. 马科夫链](https://chat.openai.com/share/ac4230fa-0f19-4607-83c2-9dc5f1c6a6dc)，内容由 [ChatGPT 3.5](https://chat.openai.com/) 生成。
