// Based on the "simple example" in the JFlex manual:
// http://jflex.de/manual.html

/* JFlex example: part of Java language lexer specification */
//import java_cup.runtime.*;
//import compiler.*;

/**
 * This class is a simple example lexer.
 */


%%

%class Lexer
%public
//not implementing compiler.* either. %extends SourceLexer
//Not implementing the Mjc* stuff. %implements MjcTokens
%unicode
%line
%column
%standalone

%{

    StringBuffer string = new StringBuffer();

    int ENDINPUT = 0;
    int BOOLEAN = 1;
    int CAND = 2;
    int CLASS = 3;
    int COR = 4;
    int ELSE = 5;
    int EQEQ = 6;
    int EXTENDS = 7;
    int FALSE = 8;
    int IDENT = 9;
    int IF = 10;
    int INT = 11;
    int INTLIT = 12;
    int NEQ = 13;
    int NEW = 14;
    int NULL = 15;
    int RETURN = 16;
    int STATIC = 17;
    int SUPER = 18;
    int THIS = 19;
    int TRUE = 20;
    int VOID = 21;
    int WHILE = 22;
    int GTEQ = 23;
    int LTEQ = 24;
    int PLUSEQ = 25;
    int MINUSEQ = 26;
    int PRIVATE = 27;
    int PROTECTED = 28;
    int PUBLIC = 29;
    int ABSTRACT = 30;
    int STRLIT = 31;
    // '!' (code=33)
    // '&' (code=38)
    // '(' (code=40)
    // ')' (code=41)
    // '*' (code=42)
    // '+' (code=43)
    // ',' (code=44)
    // '-' (code=45)
    // '.' (code=46)
    // '/' (code=47)
    // ';' (code=59)
    // '<' (code=60)
    // '=' (code=61)
    // '>' (code=62)
    // '^' (code=94)
    // '{' (code=123)
    // '|' (code=124)
    // '}' (code=125)

%}

lineterminator = \r|\n|\r\n
inputcharacter = [^\r\n]
whitespace     = {lineterminator} | [ \t\f]

comment = {traditionalcomment} | {endoflinecomment}

traditionalcomment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
endoflinecomment     = "//" {inputcharacter}* {lineterminator}
// unused: commentcontent       = ( [^*] | \*+ [^/*] )*

// Some of these macros are from/inspired by the following:
// http://users.csc.calpoly.edu/~gfisher/classes/330/examples/jflex/pascal.jflex
// changed [A-Za-z] to :jletter: to conform with Unicode.

letter          = [:letter:]
digits          = ([0-9])*
alphanumeric    = [:jletterdigit:]
other_id_char   = [_]
identifier      = {letter}({alphanumeric}|{other_id_char})*
integer         = 214748364[0-7]|21474836[0-3][0-9]|2147483[0-5][0-9][0-9]|214748[0-2][0-9][0-9][0-9]|21474[0-7][0-9][0-9][0-9][0-9]|2147[0-3][0-9][0-9][0-9][0-9][0-9]|214[0-6][0-9][0-9][0-9][0-9][0-9][0-9]|21[0-3][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|20[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|1[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]|[0-9][0-9][0-9][0-9][0-9][0-9][0-9]|[0-9][0-9][0-9][0-9][0-9][0-9]|[0-9][0-9][0-9][0-9][0-9]|[0-9][0-9][0-9][0-9]|[0-9][0-9][0-9]|[0-9][0-9]|[0-9]

%state STRING


%%
  "("     { return '('; }
  ")"     { return ')'; }
  "{"     { return '{'; }
  "}"     { return '}'; }
  ";"     { return ';'; }
  ","     { return ','; }
  "."     { return '.'; }

  "="     { return '='; }
  "=="    { return EQEQ; }

  ">"     { return '>'; }
  ">="    { return GTEQ; }
  "<"     { return '<'; }
  "<="    { return LTEQ; }
  "!"     { return '!'; }
  "!="    { return NEQ; }
  "&"     { return '&'; }
  "&&"    { return CAND; }
  "|"     { return '|'; }
  "||"    { return COR; }
  "^"     { return '^'; }
  "+"     { return '+'; }
  "+="    { return PLUSEQ; }
  "-"     { return '-'; }
  "-="    { return MINUSEQ; }
  "*"     { return '*'; }
  "/"     { return '/'; }

  // reserved identifiers
  "boolean"     { return BOOLEAN; }
  "class"       { return CLASS; }
  "else"        { return ELSE; }
  "extends"     { return EXTENDS; }
  "if"          { return IF; }
  "int"         { return INT; }
  "new"         { return NEW; }
  "return"      { return RETURN; }
  "static"      { return STATIC; }
  "super"       { return SUPER; }
  "this"        { return THIS; }
  "void"        { return VOID; }
  "while"       { return WHILE; }
  "null"        { return NULL; }
  "true"        { return TRUE; }
  "false"       { return FALSE; }
  "private"     { return PRIVATE; }
  "protected"   { return PROTECTED; }
  "public"      { return PUBLIC; }
  "abstract"    { return ABSTRACT; }

// string matching taken from:
//   http://linuxgazette.net/issue41/lopes/lopes.html
//   http://jflex.de/manual.html

<YYINITIAL> {
  \"           { string.setLength(0); yybegin(STRING); }

  {comment}    { /* throw away comments */ }
  {identifier} { return IDENT; }


  // jflex regex solution; accepts anything that fits.
  {integer}    { return INTLIT; }
  // if the digit wasn't matched in {integer}, it's too big. Fail.
  {digits}     { System.out.println("rejecting number larger than MAXINT: " + yytext() + " --\n"); }
  {whitespace} { /* ignore whitespace */ }
}

<STRING> {
         \"          { yybegin(YYINITIAL); return STRLIT; }
        [^\n\"\\]+   { string.append( yytext() ); }
        \\n          { string.append('\n'); }
        \\\"         { string.append('\"'); }
        \\           { string.append('\\'); }
} 



  // match whatever is left and complain about it.
  .            { System.out.println("Illegal char, '" + yytext() +
                   "' line: " + yyline + ", column: " + yychar); }


