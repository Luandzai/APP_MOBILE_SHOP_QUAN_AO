import React from "react";
import "./NewsPage.css"; // File CSS này bạn giữ nguyên

function NewsPage() {
  return (
    <div className="news-page-container">
      {/* --- 1. Banner chính (Ảnh cửa hàng mới, ổn định) --- */}
      <img
        src="https://images.unsplash.com/photo-1556905055-8f358a7a47b2?auto=format&fit=crop&q=80&w=2070"
        alt="Không gian bên trong cửa hàng Blank Canvas"
        className="news-banner-image"
      />

      {/* --- 2. Triết lý thương hiệu --- */}
      <section className="news-section text-center">
        <h2 className="section-title">CÂU CHUYỆN VỀ "BLANK CANVAS"</h2>
        <p>
          Chúng tôi tin rằng mỗi con người sinh ra đều là một tấm vải trắng (a
          blank canvas) thuần khiết. Cuộc sống, trải nghiệm và chính những lựa
          chọn của bạn sẽ vẽ nên bức tranh độc đáo của riêng mình. Thời trang
          không phải là để che giấu bạn, mà là để tôn vinh con người thật của
          bạn.
        </p>
        <p>
          "Blank Canvas" ra đời từ một ý tưởng đơn giản: tạo ra những trang phục
          nền tảng, tinh tế và chất lượng, để bạn tự do "vẽ" nên phong cách cá
          nhân. Chúng tôi không chạy theo xu hướng; chúng tôi tạo ra giá trị bền
          vững. Trang phục của chúng tôi là nét cọ đầu tiên, còn bạn mới chính
          là nghệ sĩ.
        </p>
      </section>

      {/* --- 3. Sứ mệnh & Tầm nhìn --- */}
      <section className="news-section">
        <h2 className="section-title">TẦM NHÌN & SỨ MỆNH</h2>
        <p className="subtitle">
          "Everyday wear for everyone" - Trang phục hàng ngày cho tất cả mọi
          người.
        </p>

        <div className="vision-mission-split">
          <div className="split-item">
            <h3>Tầm Nhìn (Vision)</h3>
            <p>
              Trở thành thương hiệu thời trang Việt Nam được yêu mến nhất, là
              biểu tượng cho sự tự tin, chính trực và phong cách sống tối giản.
              Chúng tôi khao khát mang đến một "tấm vải trắng" chất lượng cho
              mọi cá tính, trên mọi hành trình.
            </p>
          </div>
          <div className="split-item">
            <h3>Sứ Mệnh (Mission)</h3>
            <p>
              Mang đến những sản phẩm thời trang cơ bản với chất liệu vượt trội,
              thiết kế tinh tế và giá cả hợp lý. Chúng tôi cam kết xây dựng một
              môi trường làm việc hạnh phúc, một dịch vụ khách hàng xuất sắc và
              đóng góp tích cực cho cộng đồng.
            </p>
          </div>
        </div>
      </section>

      {/* --- 4. Giá trị cốt lõi --- */}
      <section className="news-section">
        <h2 className="section-title">GIÁ TRỊ CỐT LÕI</h2>
        <p className="subtitle">
          Năm giá trị cốt lõi là kim chỉ nam soi đường cho mọi quyết định tại
          Blank Canvas.
        </p>

        <ul className="values-list">
          <li>
            <h3>1. Customer Centric (Lấy khách hàng làm trung tâm)</h3>
            <p>
              Khách hàng không chỉ là thượng đế, mà là tri kỷ. Mọi hành động của
              chúng tôi đều bắt nguồn từ việc lắng nghe thấu đáo, thấu hiểu sâu
              sắc và phục vụ tận tâm. Chúng tôi không chỉ bán quần áo, chúng tôi
              mang đến sự hài lòng và niềm tin.
            </p>
          </li>
          <li>
            <h3>2. Integrity (Chính trực tuyệt đối)</h3>
            <p>
              Chúng tôi chọn làm điều đúng, ngay cả khi không ai quan sát. Trung
              thực trong từng đường kim mũi chỉ, minh bạch trong từng giao dịch,
              và giữ trọn lời hứa với khách hàng, đối tác và đồng nghiệp. Sự
              chính trực là nền móng của lòng tin.
            </p>
          </li>
          <li>
            <h3>3. Craftsmanship & Quality (Tay nghề & Chất lượng)</h3>
            <p>
              Chúng tôi bị ám ảnh bởi chất lượng. Từ việc tuyển chọn sợi vải,
              nghiên cứu phom dáng, đến sự tỉ mỉ trong từng đường may. Mỗi sản
              phẩm trước khi đến tay bạn đều là một tác phẩm được tạo ra bằng cả
              tâm huyết và niềm tự hào về tay nghề.
            </p>
          </li>
          <li>
            <h3>4. Growth Mindset (Tư duy cầu tiến)</h3>
            <p>
              Thế giới luôn vận động, và chúng tôi cũng vậy. Chúng tôi coi mỗi
              thách thức là một cơ hội để học hỏi, mỗi thất bại là một bài học
              để trưởng thành. Toàn bộ đội ngũ không ngừng học tập, cải tiến và
              hoàn thiện để hôm nay tốt hơn hôm qua.
            </p>
          </li>
          <li>
            <h3>5. Ownership & Autonomy (Làm chủ & Tự chủ)</h3>
            <p>
              Mỗi thành viên tại Blank Canvas đều là một người chủ thực thụ của
              công việc mình làm. Chúng tôi trao quyền, tin tưởng, và khuyến
              khích mọi người đưa ra quyết định vì lợi ích tốt nhất của khách
              hàng và tổ chức.
            </p>
          </li>
        </ul>
      </section>

      {/* --- 5. Bộ sưu tập (Hình ảnh sản phẩm ổn định) --- */}
      <section className="news-section">
        <h2 className="section-title">NHỮNG MẢNH GHÉP TỪ BLANK CANVAS</h2>
        <p className="subtitle">
          Được thiết kế để trường tồn với thời gian, không phải chỉ cho một mùa.
        </p>
        <div className="product-image-gallery">
          <img
            src="https://images.pexels.com/photos/4065137/pexels-photo-4065137.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
            alt="Áo thun Premium Cotton"
          />
          <img
            src="https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&q=80&w=1887"
            alt="Quần Smart Pants"
          />
          <img
            src="https://images.pexels.com/photos/8148337/pexels-photo-8148337.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
            alt="Áo sơ mi Linen"
          />
        </div>
        <p
          style={{ textAlign: "center", marginTop: "20px", fontSize: "1.1rem" }}
        >
          Khám phá những thiết kế cơ bản nhưng không hề đơn điệu, được tạo ra để
          đồng hành cùng bạn trong mọi khoảnh khắc của cuộc sống.
        </p>
      </section>

      {/* --- 6. Niềm tin & Văn hóa --- */}
      <section className="news-section text-center">
        <h2 className="section-title">NIỀM TIN CỦA CHÚNG TÔI</h2>
        <p>
          Chúng tôi tin rằng tài sản quý giá nhất của một tổ chức chính là con
          người. Tất cả các khoản chi đều là chi phí, nhưng chi cho khách hàng
          và đầu tư vào nhân viên là không bao giờ phí phạm.
        </p>
        <p>
          Mỗi thành viên của Blank Canvas, từ người thợ may đến nhân viên bán
          hàng, đều là một phần không thể thiếu của bức tranh chung. Chúng tôi
          cùng nhau nỗ lực, cùng nhau chia sẻ thành công, và cùng nhau xây dựng
          một văn hóa nơi mọi cá nhân đều được tôn trọng, được trao cơ hội và
          được là chính mình.
        </p>
      </section>

      {/* --- 7. Ảnh cuối trang (Ảnh mới, ổn định) --- */}
      <img
        src="https://images.unsplash.com/photo-1523381294911-8d3cead13475?auto=format&fit=crop&q=80&w=2070"
        alt="Một chiếc áo thun đơn giản"
        className="content-image"
      />
    </div>
  );
}

export default NewsPage;
