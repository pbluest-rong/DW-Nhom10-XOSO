# 1. Get Data -> csv file
> GetDataToCSV.run(csvFilePath): tạo csv file và ghi kết quả xổ số hôm nay: nếu hôm nay đã crawl thì lần crawl sau (cùng ngày) sẽ chỉ cập nhật file.
# 2. Load Data Source -> Staging: staging_lottery
> LoadDataToStaging.run(csvFilePath): insert dữ liệu vào staging_lottery