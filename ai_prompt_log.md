# Nhật ký trao đổi AI về Cardinality và Storage

## Index cho cột ít giá trị

**Prompt:** Vì sao B-Tree Index trên cột Boolean như `is_visible` thường không hiệu quả?

**Kết quả áp dụng:** Cột Boolean chỉ có hai giá trị. Nếu đa số bài viết có `is_visible = 1`, truy vấn sẽ trả về gần như toàn bảng. Optimizer thường thấy quét bảng rẻ hơn truy cập index rồi đọc rất nhiều dòng dữ liệu.

## Index cho nội dung văn bản

**Prompt:** Tại sao không nên dùng B-Tree prefix index cho cột `TEXT` dài khi tìm kiếm từ khóa?

**Kết quả áp dụng:** Prefix index tốn dung lượng và không phù hợp cho tìm kiếm từ ở nhiều vị trí trong đoạn văn. Khi cần tìm kiếm nội dung, nên cân nhắc `FULLTEXT` Index và truy vấn `MATCH ... AGAINST`.

## Đánh đổi Read và Write

**Prompt:** Nhiều secondary index ảnh hưởng thế nào đến INSERT và UPDATE của InnoDB?

**Kết quả áp dụng:** Mỗi thay đổi dữ liệu phải cập nhật cả clustered index lẫn các secondary index liên quan. Index tăng tốc một số truy vấn đọc, nhưng làm ghi chậm hơn và tăng chi phí lưu trữ/bộ nhớ.
