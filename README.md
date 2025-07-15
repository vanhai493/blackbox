# Wikipedia Search Automation

Dự án tự động hóa kiểm thử sử dụng Robot Framework và Selenium để thực hiện tìm kiếm trên Wikipedia.

## Mô tả

Dự án này tạo ra một bộ test tự động để:
- Mở trình duyệt và điều hướng đến Wikipedia
- Tìm kiếm từ khóa "Apple"
- Xác minh kết quả tìm kiếm
- Dọn dẹp tài nguyên sau khi hoàn thành

## Cấu trúc dự án

```
wikipedia-search-automation/
├── tests/
│   ├── wikipedia_search.robot     # Test cases chính
│   └── validation_tests.robot     # Test validation và boundary
├── resources/
│   ├── keywords/
│   │   ├── wikipedia_keywords.robot  # Keywords tùy chỉnh
│   │   └── browser_config.robot      # Cấu hình browser
│   └── variables/
│       └── test_data.robot        # Dữ liệu test và biến
├── requirements.txt               # Dependencies Python
├── run_tests.bat                 # Script chạy tất cả tests
├── run_single_test.bat           # Script chạy test đơn lẻ
└── README.md                     # Tài liệu dự án
```

## Cài đặt

### Yêu cầu hệ thống
- Python 3.8 hoặc cao hơn
- pip (Python package manager)

### Cài đặt dependencies

1. Clone hoặc tải xuống dự án
2. Mở terminal/command prompt trong thư mục dự án
3. Cài đặt các package cần thiết:

```bash
pip install -r requirements.txt
```

### Cài đặt WebDriver

Dự án sử dụng webdriver-manager để tự động quản lý driver, không cần cài đặt thủ công.

## Chạy Tests

### Sử dụng batch scripts (Windows)
```cmd
# Chạy tất cả tests
run_tests.bat

# Chỉ chạy test tìm kiếm Apple
run_single_test.bat
```

### Chạy thủ công với Robot Framework

#### Chạy tất cả tests
```bash
robot tests/
```

#### Chạy test cụ thể
```bash
robot tests/wikipedia_search.robot
robot tests/validation_tests.robot
```

#### Chạy với browser cụ thể
```bash
robot --variable BROWSER:Chrome tests/
robot --variable BROWSER:Firefox tests/
robot --variable BROWSER:Edge tests/
```

#### Chạy ở chế độ headless
```bash
robot --variable HEADLESS:True tests/
```

#### Chạy test case cụ thể
```bash
robot --test "Search Apple On Wikipedia" tests/wikipedia_search.robot
```

## Kết quả Test

Sau khi chạy test, các file kết quả sẽ được tạo:
- `report.html` - Báo cáo chi tiết
- `log.html` - Log chi tiết của test execution
- `output.xml` - Kết quả ở định dạng XML

## Cấu hình

Các cấu hình có thể được thay đổi trong file `resources/variables/test_data.robot`:
- URL Wikipedia
- Từ khóa tìm kiếm
- Timeout values
- Browser settings

## Troubleshooting

### Lỗi WebDriver
- Đảm bảo đã cài đặt webdriver-manager
- Kiểm tra kết nối internet để tải driver

### Lỗi Browser
- Đảm bảo browser được cài đặt trên hệ thống
- Thử chạy với browser khác

### Lỗi Timeout
- Tăng timeout values trong test_data.robot
- Kiểm tra kết nối internet

## Phát triển

Để thêm test cases mới:
1. Tạo keywords trong `resources/keywords/`
2. Thêm test data trong `resources/variables/`
3. Viết test cases trong `tests/`

## Liên hệ

Nếu có vấn đề hoặc câu hỏi, vui lòng tạo issue trong repository.

## Tính năng chính

### Test Cases
- **Search Apple On Wikipedia**: Test case chính tìm kiếm từ khóa "Apple"
- **Search Multiple Keywords**: Test tìm kiếm nhiều từ khóa khác nhau
- **Test Search Result Content Validation**: Kiểm tra chi tiết nội dung kết quả

### Validation Tests
- **Test Invalid Search Keywords**: Kiểm tra với từ khóa không hợp lệ
- **Test Search Result Boundaries**: Kiểm tra điều kiện biên
- **Test Multiple Browser Support**: Hỗ trợ nhiều trình duyệt
- **Test Network Timeout Scenarios**: Xử lý timeout mạng
- **Test Page Element Validation**: Kiểm tra các element trên trang

### Browser Support
- Chrome (mặc định)
- Firefox
- Microsoft Edge
- Chế độ headless cho tất cả browsers

### Error Handling
- Tự động capture screenshot khi lỗi
- Xử lý timeout gracefully
- Detailed logging cho debugging
- Cleanup tự động khi test fail

## Ví dụ Output

Khi chạy test thành công, bạn sẽ thấy:
```
==============================================================================
Wikipedia Search
==============================================================================
Search Apple On Wikipedia                                            | PASS |
------------------------------------------------------------------------------
Wikipedia Search                                                     | PASS |
1 critical test, 1 passed, 0 failed
1 test total, 1 passed, 0 failed
==============================================================================
```