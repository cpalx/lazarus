program TestUnicode;

{$mode objfpc}{$H+}

uses
  sysutils, lazutf8;

procedure WriteStringHex(Str: utf8string);
var
  StrOut: utf8string;
  i: Integer;
begin
  StrOut := '';
  for i := 1 to Length(Str) do
  begin
    StrOut := StrOut + IntToHex(Byte(Str[i]), 2) + ' ';
  end;
  Write(StrOut);
end;

procedure AssertStringOperation(AMsg, AStr1, AStr2, AStrExpected2: utf8string);
begin
  Write(AMsg, ' ', AStr1, ' => ', AStr2);
  if UTF8CompareStr(AStr2, AStrExpected2) <> 0 then
  begin
    Write(' Expected ', AStrExpected2, ' !Error!');
    WriteLn();
    Write('Got      Len=', Length(AStr2),' ');
    WriteStringHex(AStr2);
    WriteLn('');
    Write('Expected Len=', Length(AStrExpected2),' ');
    WriteStringHex(AStrExpected2);
    WriteLn();
    Write('Orig     Len=', Length(AStr1),' ');
    WriteStringHex(AStr1);
    WriteLn('');
  end;
  WriteLn();
end;

procedure AssertStringOperationUTF8UpperCase(AMsg, ALocale, AStr1, AStrExpected2: utf8string);
begin
  AssertStringOperation(AMsg, AStr1, UTF8UpperCase(AStr1, ALocale), AStrExpected2);
end;

procedure AssertStringOperationUTF8LowerCase(AMsg, ALocale, AStr1, AStrExpected2: utf8string);
begin
  AssertStringOperation(AMsg, AStr1, UTF8LowerCase(AStr1, ALocale), AStrExpected2);
//  AssertStringOperation('2'+AMsg, AStr1, UTF8LowerCase2(AStr1, ALocale), AStrExpected2);
//  AssertStringOperation('M'+AMsg, AStr1, UTF8LowerCaseMattias(AStr1), AStrExpected2);
end;

function DateTimeToMilliseconds(aDateTime: TDateTime): Int64;
var
  TimeStamp: TTimeStamp;
begin
  {Call DateTimeToTimeStamp to convert DateTime to TimeStamp:}
  TimeStamp:= DateTimeToTimeStamp (aDateTime);
  {Multiply and add to complete the conversion:}
  Result:= TimeStamp.Time;
end;

procedure TestUTF8UpperCase;
var
  lStartTime, lTimeDiff: TDateTime;
  Str: UTF8String;
  i: Integer;
begin
  // ASCII
  AssertStringOperationUTF8UpperCase('ASCII UTF8UpperCase', '', 'abcdefghijklmnopqrstuwvxyz', 'ABCDEFGHIJKLMNOPQRSTUWVXYZ');
  // Latin
  AssertStringOperationUTF8UpperCase('Portuguese UTF8UpperCase 1', '', 'Ç/ç Ã/ã Õ/õ Á/á É/é Í/í Ó/ó Ú/ú Ü/ü À/à Â/â Ê/ê Î/î Ô/ô Û/û', 'Ç/Ç Ã/Ã Õ/Õ Á/Á É/É Í/Í Ó/Ó Ú/Ú Ü/Ü À/À Â/Â Ê/Ê Î/Î Ô/Ô Û/Û');
  AssertStringOperationUTF8UpperCase('French UTF8UpperCase 1', '', 'À/à Â/â æ Ç/ç É/é È/è Ê/ê Ë/ë Î/î Ï/ï Ô/ô œ Ù/ù Û/û Ü/ü Ÿ/ÿ', 'À/À Â/Â Æ Ç/Ç É/É È/È Ê/Ê Ë/Ë Î/Î Ï/Ï Ô/Ô Œ Ù/Ù Û/Û Ü/Ü Ÿ/Ÿ');
  AssertStringOperationUTF8UpperCase('Polish UTF8UpperCase 1', '', 'aąbcćdeęfghijklłmnńoóprsśtuwyzźż', 'AĄBCĆDEĘFGHIJKLŁMNŃOÓPRSŚTUWYZŹŻ');
  AssertStringOperationUTF8UpperCase('Polish UTF8UpperCase 2', '', 'AĄBCĆDEĘFGHIJKLŁMNŃOÓPRSŚTUWYZŹŻ', 'AĄBCĆDEĘFGHIJKLŁMNŃOÓPRSŚTUWYZŹŻ');
  AssertStringOperationUTF8UpperCase('German UTF8UpperCase 1', '', 'Ä/ä,Ö/ö,Ü/ü,ß', 'Ä/Ä,Ö/Ö,Ü/Ü,SS');
  // Turkish
  AssertStringOperationUTF8UpperCase('Turkish UTF8UpperCase 1', 'tu', 'abcçdefgğhııijklmnoöprsştuüvyz', 'ABCÇDEFGĞHIIİJKLMNOÖPRSŞTUÜVYZ');
  AssertStringOperationUTF8UpperCase('Turkish UTF8UpperCase 2', 'tu', 'ABCÇDEFGĞHIIİJKLMNOÖPRSŞTUÜVYZ', 'ABCÇDEFGĞHIIİJKLMNOÖPRSŞTUÜVYZ');
  // Cyrillic
  AssertStringOperationUTF8UpperCase('Russian UTF8UpperCase 1', '', 'АБВЕЁЖЗКЛМНОПРДЙГ СУФХЦЧШЩЪЫЬЭЮЯИТ', 'АБВЕЁЖЗКЛМНОПРДЙГ СУФХЦЧШЩЪЫЬЭЮЯИТ');
  AssertStringOperationUTF8UpperCase('Russian UTF8UpperCase 2', '', 'абвеёжзклмнопрдйг суфхцчшщъыьэюяит', 'АБВЕЁЖЗКЛМНОПРДЙГ СУФХЦЧШЩЪЫЬЭЮЯИТ');

  // What shouldnt change
  AssertStringOperationUTF8UpperCase('Chinese UTF8UpperCase 1', '', '名字叫嘉英，嘉陵江的嘉，英國的英', '名字叫嘉英，嘉陵江的嘉，英國的英');

  // Performance test
  lStartTime := Now;
  for i := 0 to 9999 do
  begin
    Str := UTF8UpperCase('ABCDEFGHIJKLMNOPQRSTUWVXYZ');
    Str := Str + UTF8UpperCase('aąbcćdeęfghijklłmnńoóprsśtuwyzźż');
    Str := Str + UTF8UpperCase('AĄBCĆDEĘFGHIJKLŁMNŃOÓPRSŚTUWYZŹŻ');
  end;
  lTimeDiff := Now - lStartTime;
  WriteLn('UpperCase Performance test took: ', DateTimeToMilliseconds(lTimeDiff), ' ms');
end;

procedure TestUTF8LowerCase;
var
  k, j, i: Integer;
  lStartTime, lTimeDiff: TDateTime;
  Str: UTF8String;
const
  TimerLoop = 5999999;
begin
  // ASCII
  AssertStringOperationUTF8LowerCase('ASCII UTF8LowerCase', '', 'ABCDEFGHIJKLMNOPQRSTUWVXYZ', 'abcdefghijklmnopqrstuwvxyz');
  // Latin
  AssertStringOperationUTF8LowerCase('Portuguese UTF8LowerCase 1', '', 'Ç/ç Ã/ã Õ/õ Á/á É/é Í/í Ó/ó Ú/ú Ü/ü À/à Â/â Ê/ê Î/î Ô/ô Û/û', 'ç/ç ã/ã õ/õ á/á é/é í/í ó/ó ú/ú ü/ü à/à â/â ê/ê î/î ô/ô û/û');
  AssertStringOperationUTF8LowerCase('French UTF8LowerCase 1', '', 'À/à Â/â æ Ç/ç É/é È/è Ê/ê Ë/ë Î/î Ï/ï Ô/ô œ Ù/ù Û/û Ü/ü Ÿ/ÿ', 'à/à â/â æ ç/ç é/é è/è ê/ê ë/ë î/î ï/ï ô/ô œ ù/ù û/û ü/ü ÿ/ÿ');
  AssertStringOperationUTF8LowerCase('Polish UTF8LowerCase 1', '', 'aąbcćdeęfghijklłmnńoóprsśtuwyzźż', 'aąbcćdeęfghijklłmnńoóprsśtuwyzźż');
  AssertStringOperationUTF8LowerCase('Polish UTF8LowerCase 2', '', 'AĄBCĆDEĘFGHIJKLŁMNŃOÓPRSŚTUWYZŹŻ', 'aąbcćdeęfghijklłmnńoóprsśtuwyzźż');
  AssertStringOperationUTF8LowerCase('German UTF8LowerCase 1', '', 'Ä/ä,Ö/ö,Ü/ü,ß', 'ä/ä,ö/ö,ü/ü,ß');
  AssertStringOperationUTF8LowerCase('Latin 00C0 UTF8LowerCase', '', 'ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏ', 'àáâãäåæçèéêëìíîï');
  AssertStringOperationUTF8LowerCase('Latin 00D0 UTF8LowerCase', '', 'ÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞß', 'ðñòóôõö×øùúûüýþß');
  AssertStringOperationUTF8LowerCase('Latin 0100 UTF8LowerCase', '', 'Āā Ăă Ąą Ćć Ĉĉ Ċċ Čč Ďď', 'āā ăă ąą ćć ĉĉ ċċ čč ďď');
  AssertStringOperationUTF8LowerCase('Latin 0120 UTF8LowerCase', '', 'ĠġĢģĤĥĦħĨĩĪīĬĭĮį', 'ġġģģĥĥħħĩĩīīĭĭįį');
  AssertStringOperationUTF8LowerCase('Latin 0140 UTF8LowerCase', '', 'ŀŁłŃńŅņŇňŉŊŋŌōŎŏ', 'ŀłłńńņņňňŉŋŋōōŏŏ');
  AssertStringOperationUTF8LowerCase('Latin 0160 UTF8LowerCase', '', 'ŠšŢţŤťŦŧŨũŪūŬŭŮů', 'ššţţťťŧŧũũūūŭŭůů');
  AssertStringOperationUTF8LowerCase('Latin 0180 UTF8LowerCase', '', 'ƀ Ɓ Ƃƃ Ƅƅ Ɔ Ƈƈ Ɖ Ɗ Ƌƌ ƍ Ǝ Ə', 'ƀ ɓ ƃƃ ƅƅ ɔ ƈƈ ɖ ɗ ƌƌ ƍ ǝ ə');
  AssertStringOperationUTF8LowerCase('Latin 0190 UTF8LowerCase', '', 'ƐƑƒƓƔƕƖƗƘƙƚƛƜƝƞƟ', 'ɛƒƒɠɣƕɩɨƙƙƚƛɯɲƞɵ');
  AssertStringOperationUTF8LowerCase('Latin 01A0 UTF8LowerCase', '', 'ƠơƢƣƤƥƦƧƨƩƪƫƬƭƮƯ', 'ơơƣƣƥƥƦƨƨʃƪƫƭƭʈư');
  AssertStringOperationUTF8LowerCase('Latin 01B0 UTF8LowerCase', '', 'ưƱƲƳƴƵƶƷƸƹƺƻƼƽƾƿ', 'ưʊʋƴƴƶƶʒƹƹƺƻƽƽƾƿ');
  AssertStringOperationUTF8LowerCase('Latin 01C0 UTF8LowerCase', '', 'ǀǁǂǃǄǅǆǇǈǉǊǋǌǍǎǏ', 'ǀǁǂǃǆǆǆǉǉǉǌǌǌǎǎǐ');
  AssertStringOperationUTF8LowerCase('Latin 0200 UTF8LowerCase', '', 'ȀȁȂȃȄȅȆȇȈȉȊȋȌȍȎȏ', 'ȁȁȃȃȅȅȇȇȉȉȋȋȍȍȏȏ');
  AssertStringOperationUTF8LowerCase('Latin 0210 UTF8LowerCase', '', 'ȐȑȒȓȔȕȖȗȘșȚțȜȝȞȟ', 'ȑȑȓȓȕȕȗȗșșțțȝȝȟȟ');
  AssertStringOperationUTF8LowerCase('Latin 0220 UTF8LowerCase', '', 'ȠȡȢȣȤȥȦȧȨȩȪȫȬȭȮȯ', 'ƞȡȣȣȥȥȧȧȩȩȫȫȭȭȯȯ');
  AssertStringOperationUTF8LowerCase('Latin 0230 UTF8LowerCase', '', 'ȰȱȲȳȴȵȶȷȸȹȺȻȼȽȾȿ', 'ȱȱȳȳȴȵȶȷȸȹⱥȼȼƚⱦȿ');
  // Turkish
  AssertStringOperationUTF8LowerCase('Turkish UTF8LowerCase 1', 'tu', 'abcçdefgğhııijklmnoöprsştuüvyz', 'abcçdefgğhııijklmnoöprsştuüvyz');
  AssertStringOperationUTF8LowerCase('Turkish UTF8LowerCase 2', 'tu', 'ABCÇDEFGĞHIIİJKLMNOÖPRSŞTUÜVYZ', 'abcçdefgğhııijklmnoöprsştuüvyz');
  AssertStringOperationUTF8LowerCase('Turkish UTF8LowerCase 3', 'tu', 'AhıIxXa', 'ahııxxa');
  // Cyrillic
  AssertStringOperationUTF8LowerCase('Russian UTF8LowerCase 1', '', 'АБВЕЁЖЗКЛМНОПРДЙГ СУФХЦЧШЩЪЫЬЭЮЯИТ', 'абвеёжзклмнопрдйг суфхцчшщъыьэюяит');
  AssertStringOperationUTF8LowerCase('Russian UTF8LowerCase 2', '', 'абвеёжзклмнопрдйг суфхцчшщъыьэюяит', 'абвеёжзклмнопрдйг суфхцчшщъыьэюяит');
  AssertStringOperationUTF8LowerCase('Cyrillic UTF8UpperCase 1', '', 'Ѡѡ Ѣѣ Ѥѥ Ѧѧ Ѩѩ Ѫѫ Ѭѭ Ѯѯ Ѱѱ Ѳѳ Ѵѵ Ѷѷ Ѹѹ Ѻѻ Ѽѽ Ѿѿ Ҁҁ', 'ѡѡ ѣѣ ѥѥ ѧѧ ѩѩ ѫѫ ѭѭ ѯѯ ѱѱ ѳѳ ѵѵ ѷѷ ѹѹ ѻѻ ѽѽ ѿѿ ҁҁ');
  AssertStringOperationUTF8LowerCase('Cyrillic UTF8UpperCase 2', '', 'Ҋҋ Ҍҍ Ҏҏ Ґґ Ғғ Ҕҕ Җҗ Ҙҙ Ққ Ҝҝ Ҟҟ Ҡҡ Ңң Ҥҥ Ҧҧ Ҩҩ Ҫҫ Ҭҭ Үү Ұұ Ҳҳ Ҵҵ Ҷҷ Ҹҹ Һһ Ҽҽ Ҿҿ', 'ҋҋ ҍҍ ҏҏ ґґ ғғ ҕҕ җҗ ҙҙ ққ ҝҝ ҟҟ ҡҡ ңң ҥҥ ҧҧ ҩҩ ҫҫ ҭҭ үү ұұ ҳҳ ҵҵ ҷҷ ҹҹ һһ ҽҽ ҿҿ');
  // What shouldnt change
  AssertStringOperationUTF8LowerCase('Chinese UTF8LowerCase 1', '', '名字叫嘉英，嘉陵江的嘉，英國的英', '名字叫嘉英，嘉陵江的嘉，英國的英');
  // Georgian
  AssertStringOperationUTF8LowerCase('Georgian UTF8LowerCase 1', '', 'Ⴀⴀ Ⴁⴁ Ⴂⴂ Ⴃⴃ Ⴄⴄ Ⴅⴅ Ⴆⴆ Ⴇⴇ Ⴈⴈ Ⴉⴉ Ⴊⴊ Ⴋⴋ Ⴌⴌ Ⴍⴍ Ⴎⴎ Ⴏⴏ Ⴐⴐ Ⴑⴑ', 'ⴀⴀ ⴁⴁ ⴂⴂ ⴃⴃ ⴄⴄ ⴅⴅ ⴆⴆ ⴇⴇ ⴈⴈ ⴉⴉ ⴊⴊ ⴋⴋ ⴌⴌ ⴍⴍ ⴎⴎ ⴏⴏ ⴐⴐ ⴑⴑ');
  AssertStringOperationUTF8LowerCase('Georgian UTF8LowerCase 2', '', 'Ⴒⴒ Ⴓⴓ Ⴔⴔ Ⴕⴕ Ⴖⴖ Ⴗⴗ Ⴘⴘ Ⴙⴙ Ⴚⴚ Ⴛⴛ Ⴜⴜ Ⴝⴝ Ⴞⴞ Ⴟⴟ Ⴠⴠ Ⴡⴡ Ⴢⴢ Ⴣⴣ Ⴤⴤ Ⴥⴥ', 'ⴒⴒ ⴓⴓ ⴔⴔ ⴕⴕ ⴖⴖ ⴗⴗ ⴘⴘ ⴙⴙ ⴚⴚ ⴛⴛ ⴜⴜ ⴝⴝ ⴞⴞ ⴟⴟ ⴠⴠ ⴡⴡ ⴢⴢ ⴣⴣ ⴤⴤ ⴥⴥ');

  // repeat all tests with leading turkish i, to force offset
  // ASCII
  AssertStringOperationUTF8LowerCase('Offset ASCII UTF8LowerCase', 'tu', 'IABCDEFGHIJKLMNOPQRSTUWVXYZ', 'ıabcdefghıjklmnopqrstuwvxyz');
  // Latin
  AssertStringOperationUTF8LowerCase('Offset Portuguese UTF8LowerCase 1', 'tu', 'IÇ/ç Ã/ã Õ/õ Á/á É/é Í/í Ó/ó Ú/ú Ü/ü À/à Â/â Ê/ê Î/î Ô/ô Û/û', 'ıç/ç ã/ã õ/õ á/á é/é í/í ó/ó ú/ú ü/ü à/à â/â ê/ê î/î ô/ô û/û');
  AssertStringOperationUTF8LowerCase('Offset French UTF8LowerCase 1', 'tu', 'IÀ/à Â/â æ Ç/ç É/é È/è Ê/ê Ë/ë Î/î Ï/ï Ô/ô œ Ù/ù Û/û Ü/ü Ÿ/ÿ', 'ıà/à â/â æ ç/ç é/é è/è ê/ê ë/ë î/î ï/ï ô/ô œ ù/ù û/û ü/ü ÿ/ÿ');
  AssertStringOperationUTF8LowerCase('Offset Polish UTF8LowerCase 1', 'tu', 'Iaąbcćdeęfghijklłmnńoóprsśtuwyzźż', 'ıaąbcćdeęfghijklłmnńoóprsśtuwyzźż');
  AssertStringOperationUTF8LowerCase('Offset Polish UTF8LowerCase 2', 'tu', 'IAĄBCĆDEĘFGHIJKLŁMNŃOÓPRSŚTUWYZŹŻ', 'ıaąbcćdeęfghıjklłmnńoóprsśtuwyzźż');
  AssertStringOperationUTF8LowerCase('Offset German UTF8LowerCase 1', 'tu', 'IÄ/ä,Ö/ö,Ü/ü,ß', 'ıä/ä,ö/ö,ü/ü,ß');
  // Turkish
  AssertStringOperationUTF8LowerCase('Offset Turkish UTF8LowerCase 1', 'tu', 'Iabcçdefgğhııijklmnoöprsştuüvyz', 'ıabcçdefgğhııijklmnoöprsştuüvyz');
  AssertStringOperationUTF8LowerCase('Offset Turkish UTF8LowerCase 2', 'tu', 'IABCÇDEFGĞHIIİJKLMNOÖPRSŞTUÜVYZ', 'ıabcçdefgğhııijklmnoöprsştuüvyz');
  AssertStringOperationUTF8LowerCase('Offset Turkish UTF8LowerCase 1', 'tu', 'IAhıIxXa', 'ıahııxxa');
  // Cyrillic
  AssertStringOperationUTF8LowerCase('Offset Russian UTF8LowerCase 1', 'tu', 'IАБВЕЁЖЗКЛМНОПРДЙГ СУФХЦЧШЩЪЫЬЭЮЯИТ', 'ıабвеёжзклмнопрдйг суфхцчшщъыьэюяит');
  AssertStringOperationUTF8LowerCase('Offset Russian UTF8LowerCase 2', 'tu', 'Iабвеёжзклмнопрдйг суфхцчшщъыьэюяит', 'ıабвеёжзклмнопрдйг суфхцчшщъыьэюяит');
  AssertStringOperationUTF8LowerCase('Offset Cyrillic UTF8UpperCase 1', 'tu', 'IѠѡ Ѣѣ Ѥѥ Ѧѧ Ѩѩ Ѫѫ Ѭѭ Ѯѯ Ѱѱ Ѳѳ Ѵѵ Ѷѷ Ѹѹ Ѻѻ Ѽѽ Ѿѿ Ҁҁ', 'ıѡѡ ѣѣ ѥѥ ѧѧ ѩѩ ѫѫ ѭѭ ѯѯ ѱѱ ѳѳ ѵѵ ѷѷ ѹѹ ѻѻ ѽѽ ѿѿ ҁҁ');
  AssertStringOperationUTF8LowerCase('Offset Cyrillic UTF8UpperCase 2', 'tu', 'IҊҋ Ҍҍ Ҏҏ Ґґ Ғғ Ҕҕ Җҗ Ҙҙ Ққ Ҝҝ Ҟҟ Ҡҡ Ңң Ҥҥ Ҧҧ Ҩҩ Ҫҫ Ҭҭ Үү Ұұ Ҳҳ Ҵҵ Ҷҷ Ҹҹ Һһ Ҽҽ Ҿҿ', 'ıҋҋ ҍҍ ҏҏ ґґ ғғ ҕҕ җҗ ҙҙ ққ ҝҝ ҟҟ ҡҡ ңң ҥҥ ҧҧ ҩҩ ҫҫ ҭҭ үү ұұ ҳҳ ҵҵ ҷҷ ҹҹ һһ ҽҽ ҿҿ');
  // What shouldnt change
  AssertStringOperationUTF8LowerCase('Offset Chinese UTF8LowerCase 1', 'tu', 'I名字叫嘉英，嘉陵江的嘉，英國的英', 'ı名字叫嘉英，嘉陵江的嘉，英國的英');
  // Georgian
  AssertStringOperationUTF8LowerCase('Offset Georgian UTF8LowerCase 1', 'tu', 'IႠⴀ Ⴁⴁ Ⴂⴂ Ⴃⴃ Ⴄⴄ Ⴅⴅ Ⴆⴆ Ⴇⴇ Ⴈⴈ Ⴉⴉ Ⴊⴊ Ⴋⴋ Ⴌⴌ Ⴍⴍ Ⴎⴎ Ⴏⴏ Ⴐⴐ Ⴑⴑ', 'ıⴀⴀ ⴁⴁ ⴂⴂ ⴃⴃ ⴄⴄ ⴅⴅ ⴆⴆ ⴇⴇ ⴈⴈ ⴉⴉ ⴊⴊ ⴋⴋ ⴌⴌ ⴍⴍ ⴎⴎ ⴏⴏ ⴐⴐ ⴑⴑ');
  AssertStringOperationUTF8LowerCase('Offset Georgian UTF8LowerCase 2', 'tu', 'IႲⴒ Ⴓⴓ Ⴔⴔ Ⴕⴕ Ⴖⴖ Ⴗⴗ Ⴘⴘ Ⴙⴙ Ⴚⴚ Ⴛⴛ Ⴜⴜ Ⴝⴝ Ⴞⴞ Ⴟⴟ Ⴠⴠ Ⴡⴡ Ⴢⴢ Ⴣⴣ Ⴤⴤ Ⴥⴥ', 'ıⴒⴒ ⴓⴓ ⴔⴔ ⴕⴕ ⴖⴖ ⴗⴗ ⴘⴘ ⴙⴙ ⴚⴚ ⴛⴛ ⴜⴜ ⴝⴝ ⴞⴞ ⴟⴟ ⴠⴠ ⴡⴡ ⴢⴢ ⴣⴣ ⴤⴤ ⴥⴥ');

  // Performance test
{  Write('Mattias LowerCase- Performance test took:    ');
  for j := 0 to 9 do begin
    lStartTime := Now;
    for i := 0 to TimerLoop do
    begin
      if j = 0 then Str := UTF8LowerCaseMattias('abcdefghijklmnopqrstuwvxyz');
      if j = 1 then Str := UTF8LowerCaseMattias('ABCDEFGHIJKLMNOPQRSTUWVXYZ');
      if j = 2 then Str := UTF8LowerCaseMattias('aąbcćdeęfghijklłmnńoóprsśtuwyzźż');
      if j = 3 then Str := UTF8LowerCaseMattias('AĄBCĆDEĘFGHIJKLŁMNŃOÓPRSŚTUWYZŹŻ');
      if j = 4 then Str := UTF8LowerCaseMattias('АБВЕЁЖЗКЛМНОПРДЙГ');
      if j = 5 then Str := UTF8LowerCaseMattias('名字叫嘉英，嘉陵江的嘉，英國的英');
      if j = 6 then Str := UTF8LowerCaseMattias('AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuWvVwXxYyZz');
      if j = 7 then Str := UTF8LowerCaseMattias('AAaaBBbbCCccDDddEEeeFFffGGggHHhhIIiiJJjjKKkkLLllMMmm');
      if j = 8 then Str := UTF8LowerCaseMattias('abcDefgHijkLmnoPqrsTuwvXyz');
      if j = 9 then Str := UTF8LowerCaseMattias('ABCdEFGhIJKlMNOpQRStUWVxYZ');
    end;
    lTimeDiff := Now - lStartTime;
    Write(Format(' %7d ms ', [DateTimeToMilliseconds(lTimeDiff)]));
  end;
  writeln;}
  Write('       LowerCase-- Performance test took:    ');
  for j := 0 to 9 do begin
    lStartTime := Now;
    for i := 0 to TimerLoop do
    begin
      if j = 0 then Str := UTF8LowerCase('abcdefghijklmnopqrstuwvxyz');
      if j = 1 then Str := UTF8LowerCase('ABCDEFGHIJKLMNOPQRSTUWVXYZ');
      if j = 2 then Str := UTF8LowerCase('aąbcćdeęfghijklłmnńoóprsśtuwyzźż');
      if j = 3 then Str := UTF8LowerCase('AĄBCĆDEĘFGHIJKLŁMNŃOÓPRSŚTUWYZŹŻ');
      if j = 4 then Str := UTF8LowerCase('АБВЕЁЖЗКЛМНОПРДЙГ');
      if j = 5 then Str := UTF8LowerCase('名字叫嘉英，嘉陵江的嘉，英國的英');
      if j = 6 then Str := UTF8LowerCase('AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuWvVwXxYyZz');
      if j = 7 then Str := UTF8LowerCase('AAaaBBbbCCccDDddEEeeFFffGGggHHhhIIiiJJjjKKkkLLllMMmm');
      if j = 8 then Str := UTF8LowerCase('abcDefgHijkLmnoPqrsTuwvXyz');
      if j = 9 then Str := UTF8LowerCase('ABCdEFGhIJKlMNOpQRStUWVxYZ');
    end;
    lTimeDiff := Now - lStartTime;
    Write(Format(' %7d ms ', [DateTimeToMilliseconds(lTimeDiff)]));
  end;
  writeln;
  Write('       LowerCase2-- Performance test took:    ');
  for j := 0 to 9 do begin
    lStartTime := Now;
    for i := 0 to TimerLoop do
    begin
      if j = 0 then Str := UTF8LowerCase2('abcdefghijklmnopqrstuwvxyz');
      if j = 1 then Str := UTF8LowerCase2('ABCDEFGHIJKLMNOPQRSTUWVXYZ');
      if j = 2 then Str := UTF8LowerCase2('aąbcćdeęfghijklłmnńoóprsśtuwyzźż');
      if j = 3 then Str := UTF8LowerCase2('AĄBCĆDEĘFGHIJKLŁMNŃOÓPRSŚTUWYZŹŻ');
      if j = 4 then Str := UTF8LowerCase2('АБВЕЁЖЗКЛМНОПРДЙГ');
      if j = 5 then Str := UTF8LowerCase2('名字叫嘉英，嘉陵江的嘉，英國的英');
      if j = 6 then Str := UTF8LowerCase2('AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuWvVwXxYyZz');
      if j = 7 then Str := UTF8LowerCase2('AAaaBBbbCCccDDddEEeeFFffGGggHHhhIIiiJJjjKKkkLLllMMmm');
      if j = 8 then Str := UTF8LowerCase2('abcDefgHijkLmnoPqrsTuwvXyz');
      if j = 9 then Str := UTF8LowerCase2('ABCdEFGhIJKlMNOpQRStUWVxYZ');
    end;
    lTimeDiff := Now - lStartTime;
    Write(Format(' %7d ms ', [DateTimeToMilliseconds(lTimeDiff)]));
  end;
  writeln;
  Write('   Turk LowerCase-- Performance test took:    ');
  for j := 0 to 9 do begin
    lStartTime := Now;
    for i := 0 to TimerLoop do
    begin
      if j = 0 then Str := UTF8LowerCase('Iabcdefghijklmnopqrstuwvxyz', 'tu');
      if j = 1 then Str := UTF8LowerCase('IABCDEFGHIJKLMNOPQRSTUWVXYZ', 'tu');
      if j = 2 then Str := UTF8LowerCase('Iaąbcćdeęfghijklłmnńoóprsśtuwyzźż', 'tu');
      if j = 3 then Str := UTF8LowerCase('IAĄBCĆDEĘFGHIJKLŁMNŃOÓPRSŚTUWYZŹŻ', 'tu');
      if j = 4 then Str := UTF8LowerCase('IАБВЕЁЖЗКЛМНОПРДЙГ', 'tu');
      if j = 5 then Str := UTF8LowerCase('I名字叫嘉英，嘉陵江的嘉，英國的英', 'tu');
      if j = 6 then Str := UTF8LowerCase('IAaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuWvVwXxYyZz', 'tu');
      if j = 7 then Str := UTF8LowerCase('IAAaaBBbbCCccDDddEEeeFFffGGggHHhhIIiiJJjjKKkkLLllMMmm', 'tu');
      if j = 8 then Str := UTF8LowerCase('IabcDefgHijkLmnoPqrsTuwvXyz', 'tu');
      if j = 9 then Str := UTF8LowerCase('IABCdEFGhIJKlMNOpQRStUWVxYZ', 'tu');
    end;
    lTimeDiff := Now - lStartTime;
    Write(Format(' %7d ms ', [DateTimeToMilliseconds(lTimeDiff)]));
  end;
  writeln;
  Write('   Turk LowerCase2-- Performance test took:    ');
  for j := 0 to 9 do begin
    lStartTime := Now;
    for i := 0 to TimerLoop do
    begin
      if j = 0 then Str := UTF8LowerCase2('Iabcdefghijklmnopqrstuwvxyz', 'tu');
      if j = 1 then Str := UTF8LowerCase2('IABCDEFGHIJKLMNOPQRSTUWVXYZ', 'tu');
      if j = 2 then Str := UTF8LowerCase2('Iaąbcćdeęfghijklłmnńoóprsśtuwyzźż', 'tu');
      if j = 3 then Str := UTF8LowerCase2('IAĄBCĆDEĘFGHIJKLŁMNŃOÓPRSŚTUWYZŹŻ', 'tu');
      if j = 4 then Str := UTF8LowerCase2('IАБВЕЁЖЗКЛМНОПРДЙГ', 'tu');
      if j = 5 then Str := UTF8LowerCase2('I名字叫嘉英，嘉陵江的嘉，英國的英', 'tu');
      if j = 6 then Str := UTF8LowerCase2('IAaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuWvVwXxYyZz', 'tu');
      if j = 7 then Str := UTF8LowerCase2('IAAaaBBbbCCccDDddEEeeFFffGGggHHhhIIiiJJjjKKkkLLllMMmm', 'tu');
      if j = 8 then Str := UTF8LowerCase2('IabcDefgHijkLmnoPqrsTuwvXyz', 'tu');
      if j = 9 then Str := UTF8LowerCase2('IABCdEFGhIJKlMNOpQRStUWVxYZ', 'tu');
    end;
    lTimeDiff := Now - lStartTime;
    Write(Format(' %7d ms ', [DateTimeToMilliseconds(lTimeDiff)]));
  end;
  writeln;
end;

begin
  WriteLn('======= UpperCase =======');
  TestUTF8UpperCase();
  WriteLn('======= LowerCase =======');
  TestUTF8LowerCase();
  WriteLn('Please press enter to continue');
  readln;
end.

