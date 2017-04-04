grammar MokadiGrammar_fr;

// code UTF-8 http://www.utf8-chartable.de/

parse
    : mokadi expression_stmt questions_mark? EOF
    ;
    
/////////////
// expression
/////////////

expression_stmt
    : expression
    | ('(' expression ')')
    ;

expression
    : slides_stmt
    | anything_stmt
    | mail_stmt
    | news_stmt
    | emotion_stmt
    ;
    
slides_stmt
    : verb_voir stop_words? presentation (integer_number_string slides integer_number_string)?
    ;
    
mail_stmt
    : verb_voir stop_words? time_indication? 
      integer_number_string? mails (integer_number_string with_body?)?
    ;
    
news_stmt
    : ((verb_voir stop_words? time_indication? news) news_query?)
    | (news news_query?)
    ;
    
news_query
    : apropos stop_words? stop_words? word_name+
    ;
    
emotion_stmt
    : verb_voir? possessif_me? humeur
    ;

anything_stmt
    : word_name word_name* question?
    ;

/////////////
// mokadi
////////////

mokadi
    : 'MOKADI'
    | 'mokadie'
    | 'leocadie'
    | 'Leocadie'
    ;
    
humeur
    : 'humeur'
    ;
    
presentation
    : Presentation
    | 'powerpoint'
    ;
    
news
    : 'nouvelles'
    | 'nouvelle'
    | 'news'
    | 'informations'
    | 'information'
    ;
    
time_indication
    : Dernieres
    | Recent
    | 'nouvelles'
    | 'nouvelle'
    | 'nouveau'
    | 'nouveaux'
    ;
    
with_body
    : stop_words 'entier'
    ;
    
Dernieres
    : 'derni' E_CODE 'r' 'e'? 's'?
    ; 

Recent
    : 'r' E_CODE 'cent' 'e'? 's'?
    ; 

Presentation
    : 'pr' E_CODE 'sentation' 's'?
    ;    
    
apropos
    : (Astopword 'propos')
    | 'sur'
    ;    
    
slides
    : 'slides'
    | 'slide'
    | 'transparent'
    ;
    
mails
    : 'mail'
    | 'mails'
    | 'email'
    | 'mel'
    | 'emails'
    | 'mels'
    ;
    
verb_voir
    : 'lit'
    | 'voir'
    | 'list'
    | 'lire'
    | 'liste'
    | 'lister'
    | ('quelles' 'sont')
    | ('quel' 'sont')
    | ('quelle' 'est')
    | ('quel' 'est')
    ;
    
stop_words
    : 'les' | 'le' | 'la'
    | Astopword
    | 'du' | 'de' | 'des'
    | 'en'
    ;
    
possessif_me
    : 'mon' | 'ma' | 'mes'
    ;
    
Astopword
    : A_CODE
    ;
        
questions_mark
    :'?'
    ;
    
////////
// rules
////////

integer_number_string
    : integer_number
    | number_name
    ;

number_name
    : 'un' | 'deux' | 'trois' | 'quatre' | 'cinq'
    | 'six' | 'sept' | 'huit' | 'neuf' | 'dix'
    | 'onze' | 'douze' | 'treize' 
    | 'vingt' | 'trente'
    | 'cinquante'
    | ('cent' 's'?)
    | 'mille'
    | ('million' 's'?)
    | ('millard' 's'?)
    ;

word_name
    : Identifier
    | constant
    | operator
    ;
    
operator
    : '+' | '-' | '*' | '/' | '%' | '&&' | '||' | '==' | '!=' | '<=' | '>=' | '>' | '<'
    ;
    
question
    : '?'
    ;

constant
    : integer_number
    | real_number
    | string_literal
    ;

string_literal
    : STRING
    ;

integer_number
    : Sign? Digits
    ;
    
real_number
    : (Sign? Digits '.' Digits ('e' Sign? Digits)?)
    | (Sign? Digits 'e' Sign? Digits)
    ;
    

/////////
// tokens
/////////

Digits
    : DIGIT+
    ;
    
Sign
    : '-'
    | '+'
    ;

Identifier
    : LETTER LETTER_DIGIT*
    ;
    
fragment E_CODE
    : '\u00E8' | '\u00E9' | '\u00EA' | '\u00EB' | 'é' | 'e' | 'è' | 'ê' | 'ë'
    ;
    
fragment A_CODE
    : '\u00E0' | 'à'
    ;
    
STRING
    : STRING_DOUBLE_QUOTE
    | STRING_QUOTE
    ;
    
STRING_DOUBLE_QUOTE
    : '"' (NO_DOUBLE_QUOTE | '\\"')* '"'
    ;
    
STRING_QUOTE
    : '\'' (NO_QUOTE | '\\\'')* '\''
    ;
    
fragment NO_QUOTE
    : ~[']
    ;

fragment NO_DOUBLE_QUOTE
    : ~["]
    ;

fragment LETTER_DIGIT
    : LETTER | DIGIT
    ;
    
fragment DIGIT
    : [0-9]
    ;

fragment LETTER      
    : [a-zA-Z\u0080-\u00FF_] 
    ;
    
LINE_COMMENT:   '#' .*? '\r'? '\n' {skip();} ;

WS          :   [ \t\r\n] -> skip ;

