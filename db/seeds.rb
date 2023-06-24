# 2022年のランダムな日時を生成するメソッド
def random_time_in_2022
  Time.new(2022, rand(1..12), rand(1..28), rand(24), rand(60), rand(60))
end

# presentsテーブルにシードデータを10件生成する
1.times do
  Present.create(
    sendfrom_id: 3, # sendfrom_idには1から100のランダムな整数を設定
    sendto_id: 3, # sendto_idには1から100のランダムな整数を設定
    content: "helllllllo", # contentにはFaker gemを使ってランダムな文を設定
    created_at: random_time_in_2022, # created_atには2022年のランダムな日時を設定
  )
end