# SymbolCounter

A Swift command-line tool to count symbols in source files.

## Example

### Input

`symbol-counter <path-to-swift-code-folder>`

### Output

Note: A single quote is added so google sheets doesn't process it as a formula.

```
File count: 570
Line count: 81310

Symbols count
'. 46641
') 44355
'( 44353
', 34705
': 22516
'/ 18741
'= 15894
'{ 13405
'} 13395
'_ 10148
'> 8721
'" 6878
'] 6745
'[ 6744
'- 6282
'< 5889
'* 2934
'` 2769
'! 1644
'? 1514
'# 1458
'+ 1413
'$ 1036
'@ 740
'\ 644
'' 310
'| 283
'& 262
'; 61
'% 35
'^ 5
'~ 5

Adjacent symbols count
'), 8892
'() 8595
'// 8234
']) 3983
'-> 2961
')) 2314
'== 1644
'(" 1629
'). 1624
'", 1567
'([ 1565
'(_ 1461
'") 1301
'** 1112
'(. 942
'}) 874
'>( 853
'}, 754
'>, 715
'*/ 712
'/* 712
'-- 705
')] 701
'>) 606
'>. 502
']( 440
'\( 428
'.. 395
'[] 363
'`. 346
':/ 343
']. 310
'!. 304
'_, 289
')" 288
'>] 285
'(( 274
':) 245
'_: 237
'[( 236
'): 233
'>> 231
'+= 228
'], 227
'?. 168
'"\ 162
'?> 160
'(# 153
'>: 147
'.< 147
```
