# 簡體轉台灣正體 (S2TwTrans.jl)

## 使用方法

- 一般使用：
    ```julia
    using S2TwTrans

    s2tw(str) # str: 要轉換的文字
    ```

- 重複使用：
    為了避免重複讀取轉換表，可以先單獨載入對照表再轉換
    ```julia
    s2tw_c = S2TwConfig() # 載入對照表
    
    s2tw(str, s2tw_c)
    ```

## 特例處理

- 包含：
    - 并 <-> 並
    - 么 <-> 麼
    - 丰 <-> 豐
    - 里 <-> 裡
    - 干 <-> 乾
    - 后 <-> 後
    - 划 <-> 劃
    - 几 <-> 幾
    - 占 <-> 佔
    - 准 <-> 準
    - 无 <-> 無
    - 于 <-> 於

- 規則：
    - 絕大部分情況以上述規則轉換。
    - 遇不需要轉換之情況，以例外的方式新增至用語中處理之。
