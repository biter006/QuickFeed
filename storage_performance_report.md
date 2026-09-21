# Báo cáo storage và performance QuickFeed

Ban đầu bảng `Posts` có năm secondary index, nên mỗi lần `INSERT` MySQL không chỉ ghi dữ liệu bài viết mà còn phải duy trì năm cấu trúc B-Tree. Điều này làm tăng thao tác ghi, dùng thêm RAM/Disk và có thể gây tranh chấp tài nguyên khi lượng bài viết lớn.

Ba index bị loại bỏ là `idx_content`, `idx_post_type` và `idx_is_visible`. `content` là TEXT dài; tìm kiếm nội dung nên dùng `FULLTEXT` khi có nhu cầu. `post_type` chỉ có ba giá trị và `is_visible` chỉ có hai giá trị, nên cardinality thấp: truy vấn thường trả về quá nhiều dòng và Optimizer có thể chọn quét bảng thay vì dùng index.

Hai index được giữ lại là `idx_user_id` để tải bài viết của một người dùng và `idx_created_at` để sắp xếp Newsfeed theo thời gian. Sau khi chạy script, cần ghi số liệu từ `information_schema.TABLES` vào bảng sau:

| Chỉ số | Trước tối ưu | Sau tối ưu |
| --- | ---: | ---: |
| Data size MB | ... | ... |
| Index size MB | ... | ... |
| Estimated rows | ... | ... |

Data size thường gần như không đổi; Index size phải giảm. Đổi lại, các truy vấn lọc chỉ theo `post_type` hoặc `is_visible` có thể chậm hơn, nhưng thao tác INSERT được giảm ba lần cập nhật B-Tree phụ.
