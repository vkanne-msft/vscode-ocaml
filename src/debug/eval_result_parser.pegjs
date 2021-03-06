{
function fixList(list) {
	return list || [];
}
function fixList1(head, tail) {
	return [head].concat(tail.map(function (item) {
    	return item[3];
    }));
}
}

msg = name:id ':' _ type:type '=' _ value:value { return {name: name, type: type.trim(), value: value}; }
id = $([A-Za-z_'][A-Za-z_'.0-9]*)
type = $([^=]+)
value = tuple
tuple = head:primary tail:(_ ',' _ primary)* { var items = fixList1(head, tail); return items.length === 1 ? items[0] : {kind: 'tuple', items: items}; }
unit = '()' { return {kind: 'plain', value: '()'}; }
paren = '(' _ value:value _ ')' { return value; }
primary = unit / paren / string / char / con / record / array / list / plain
con = con:id _ args:value { return {kind: 'con', con:con, args: args}; }
record = '{' _ list:field_list? _ '}' { return {kind: 'record', items: fixList(list)} }
field = name:id _ '=' _ value:value { return {name: name, value: value}; }
field_list = head:field tail:(_ ';' _ field)* { return fixList1(head, tail); }
array
  = '[||]' { return {kind: 'array', items: []}; }
  / '[|' _ list:value_list _ '|]' { return {kind: 'array', items: list}; }
list
  = '[]' { return {kind: 'array', items: []}; }
  / '[' _ list:value_list _ ']' { return {kind: 'list', items: list}; }
value_list = head:value tail:(_ ';' _ value)* { return fixList1(head, tail); }
string = value:$('"' ([^\\"] / '\\' .)* '"') { return {kind: 'plain', value: value}; }
char = value:$('\'' ([^\\'] / '\\\'' / '\\' [^']+) '\'') { return {kind: 'plain', value: value}; }
plain = value:$([^{}[\](),;|]+) { return {kind: 'plain', value:value}; }
_ = $([ \t\r\n]*) {}
