□HealthKit有効化手順
1. プロジェクトファイルを開く（xxx.xcodeproj）
2. TARGETSのExtensionを開く（WatchOSアプリであればProjectName WatchKit Extension）
3. Infoタブに下記の3つを追加する
    1. Privacy - Health Share Usage Description
    2. Privacy - Health Update Usage Description
    3. Privacy - Health Records Usage Description
        1. Valueは英語ならなんでも良いがAccess to Health Dataとでもしておく
4. Signing & Capabilitiesタブの+CapabilityよりHealthKitをダブルクリック
    1. Signing & Capabilitiesタブにチェックボックスが現れるがグレーアウトしている場合は下記を追加
    2. 新しく作成されたProjectName Extension.entitlementsを開く
    3. HealthKit Capabilitiesの文字の左にある横向き矢印を押して下向き矢印に変え、+を押す
    4. Item 0 (HealthKit Capability)のKeyのValue欄右の上下矢印を押してHealth Recordを選択
