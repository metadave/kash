grammar Kash;

stmts: connect_stmt | create_topic | describe_topic;

connect_stmt      :  CONNECT hps+=hostport SEMI;

// TODO: NOT REALLY A HOSTNAME REGEX!
hostport          : host=ID ':' port=INT;

create_topic : CREATE TOPIC topicname=string_value WITH keyvalues SEMI;

describe_topic : DESCRIBE TOPIC topicname=string_value SEMI;

keyvalues: kvs+=keyvalue (AND kvs+=keyvalue)*;

keyvalue: keyname=ID EQUALS thevalue=valuetype;

valuetype : string_value | INT | FLOAT;

string_value : SINGLE_STRING | DOUBLE_STRING;

/*
create topic "test" with replication_factor=1 and partitions=1;
describe topic "test";
*/

CONNECT     :    'connect';
CREATE      :    'create';
TOPIC       :    'topic';
DESCRIBE    :    'describe';
WITH        :    'with';
AND         :    'and';
OR          :    'or';
NOT         :    'not';

AT          :    '@';
DOLLAR      :    '$';
SPLAT       :    '*';
COMMA       :    ',';
LSQUARE     :    '[';
RSQUARE     :    ']';
LPAREN      :    '(';
RPAREN      :    ')';
EQUALS      :    '=';
DOT         :    '.';
SEMI        :    ';';
ID          :       LOWER (UPPER | LOWER | DIGIT | '-' | '_' | '.')*;

fragment LOWER : 'a' .. 'z';
fragment UPPER : 'A' .. 'Z';

INT             :   DIGIT+;
fragment DIGIT  : '0' .. '9';

FLOAT       :       DIGIT+ DOT DIGIT*
                    | DOT DIGIT+
                       ;

// double quoted string
DOUBLE_STRING  :  '"' (ESC|.)*? '"';
fragment ESC : '\\"' | '\\\\' ;

// single quoted string
SINGLE_STRING  :  '\'' (SESC|.)*? '\'';
fragment SESC : '\\\'' | '\\\\' ;

// scissors op, dude riding a pterodactyl, drunken bird
DATA_CONTENT: '~%~' (DATA_ESC|.)*? '~%~';
fragment DATA_ESC: '\\~%~' | '\\~%~';


LINE_COMMENT  : '//' .*? '\r'? '\n' -> skip ;
COMMENT       : '/*' .*? '*/'       -> skip ;

// unicode space chars generated by http://unicode.org/cldr/utility/list-unicodeset.jsp?a=%5B%3AZs%3A%5D&g=
WS      :       (WSCHARS | Zs | Cc)+ -> channel(HIDDEN);

WSCHARS:
[ \t\r\n];

fragment Zs:
    '\u0020' |
    '\u3000' |
    '\u1680' |
    '\u2000'..'\u2006' |
    '\u2008'..'\u200A' |
    '\u205F' |
    '\u00A0' |
    '\u2007' |
    '\u202F';

fragment Cc:
    '\u0000'..'\u0008' |
    '\u000E'..'\u001F' |
    '\u007F'..'\u0084' |
    '\u0086'..'\u009F' |
    '\u0009'..'\u000D' |
    '\u0085';