// 背题队列里的一项：够翻页与列表用，**不含内容** —— 内容按需取。
//
// 单独成文件是因为页面（造队列）与主体（消费队列）都要用这个类型，
// 而它们现在分处两个文件。

typedef ReciteEntry = ({String questionId, String stemText, String qtype});
