// client/src/components/AdminSizeChartModal.jsx
import React, { useState, useEffect, useContext } from "react";
import { Modal, Button, Form, Alert, Spinner } from "react-bootstrap";
import AuthContext from "../context/AuthContext";
import { toast } from "react-toastify";

const AdminSizeChartModal = ({ show, onHide, category }) => {
  const { api } = useContext(AuthContext);
  // data structure: { headers: ["Size", "Dài", "Rộng"], rows: [ ["S", "60", "40"], ["M", "62", "42"] ] }
  const [tableData, setTableData] = useState({ headers: [], rows: [] });
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [useHtmlMode, setUseHtmlMode] = useState(false); // Fallback for legacy or advanced users
  const [htmlContent, setHtmlContent] = useState("");
  const [isFreesize, setIsFreesize] = useState(false);
  const [freesizeContent, setFreesizeContent] = useState("");

  // Load dữ liệu cũ khi mở modal
  useEffect(() => {
    if (show && category) {
      const fetchSizeChart = async () => {
        setLoading(true);
        try {
          const { data } = await api.get(`/sizecharts/${category.DanhMucID}`);
          const rawData = data.MoTa;

          if (rawData) {
            try {
              // Try to parse as JSON
              const parsed = JSON.parse(rawData);
              
              if (parsed.type === "freesize") {
                setIsFreesize(true);
                setFreesizeContent(parsed.content || "Sản phẩm này là Freesize, phù hợp với mọi kích cỡ.");
                setUseHtmlMode(false);
              } else if (parsed && Array.isArray(parsed.headers) && Array.isArray(parsed.rows)) {
                setTableData(parsed);
                setUseHtmlMode(false);
                setIsFreesize(false);
              } else {
                // Valid JSON but not our schema, or just a string that looks like JSON?
                // Treat as HTML/String if schema doesn't match
                setHtmlContent(rawData);
                setUseHtmlMode(true);
                setIsFreesize(false);
              }
            } catch (e) {
              // Not JSON, treat as HTML
              setHtmlContent(rawData);
              setUseHtmlMode(true);
              setIsFreesize(false);
            }
          } else {
            // New, load default template
            loadDefaultTemplate();
          }
        } catch (error) {
          console.error(error);
          toast.error("Lỗi tải bảng size");
        } finally {
          setLoading(false);
        }
      };
      fetchSizeChart();
    }
  }, [show, category, api]);

  const loadDefaultTemplate = () => {
    setTableData({
      headers: ["Size", "Chiều cao (cm)", "Cân nặng (kg)"],
      rows: [
        ["S", "150 - 160", "45 - 55"],
        ["M", "160 - 170", "55 - 65"],
        ["L", "170 - 175", "65 - 75"],
        ["XL", "175 - 180", "75 - 85"],
      ],
    });
    setUseHtmlMode(false);
    setIsFreesize(false);
    setFreesizeContent("Sản phẩm này là Freesize, phù hợp với mọi kích cỡ.");
  };

  const handleHeaderChange = (index, value) => {
    const newHeaders = [...tableData.headers];
    newHeaders[index] = value;
    setTableData({ ...tableData, headers: newHeaders });
  };

  const handleRowChange = (rowIndex, colIndex, value) => {
    const newRows = [...tableData.rows];
    newRows[rowIndex][colIndex] = value;
    setTableData({ ...tableData, rows: newRows });
  };

  const addColumn = () => {
    const newHeaders = [...tableData.headers, "New Column"];
    const newRows = tableData.rows.map((row) => [...row, ""]);
    setTableData({ headers: newHeaders, rows: newRows });
  };

  const removeColumn = (index) => {
    if (tableData.headers.length <= 1) return;
    const newHeaders = tableData.headers.filter((_, i) => i !== index);
    const newRows = tableData.rows.map((row) => row.filter((_, i) => i !== index));
    setTableData({ headers: newHeaders, rows: newRows });
  };

  const addRow = () => {
    const newRow = new Array(tableData.headers.length).fill("");
    setTableData({ ...tableData, rows: [...tableData.rows, newRow] });
  };

  const removeRow = (index) => {
    const newRows = tableData.rows.filter((_, i) => i !== index);
    setTableData({ ...tableData, rows: newRows });
  };

  const handleSubmit = async () => {
    setSaving(true);
    try {
      let payload = "";
      if (isFreesize) {
        payload = JSON.stringify({
          type: "freesize",
          content: freesizeContent
        });
      } else if (useHtmlMode) {
        payload = htmlContent;
      } else {
        payload = JSON.stringify(tableData);
      }

      await api.post("/sizecharts", {
        DanhMucID: category.DanhMucID,
        MoTa: payload,
      });
      toast.success("Lưu bảng size thành công!");
      onHide();
    } catch (error) {
      toast.error("Lỗi khi lưu bảng size");
    } finally {
      setSaving(false);
    }
  };

  return (
    <Modal show={show} onHide={onHide} size="xl" centered>
      <Modal.Header closeButton>
        <Modal.Title>
          Cấu hình Bảng Size cho: <strong>{category?.TenDanhMuc}</strong>
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {loading ? (
          <div className="text-center py-4">
            <Spinner animation="border" />
          </div>
        ) : (
          <>
            <div className="d-flex justify-content-between mb-3 align-items-center flex-wrap gap-2">
              <div className="d-flex gap-3">
                <Form.Check
                  type="switch"
                  id="freesize-mode-switch"
                  label="Sản phẩm Freesize / Một cỡ"
                  checked={isFreesize}
                  onChange={(e) => setIsFreesize(e.target.checked)}
                />
                {!isFreesize && (
                  <Form.Check
                    type="switch"
                    id="html-mode-switch"
                    label="Chế độ HTML (Legacy)"
                    checked={useHtmlMode}
                    onChange={(e) => setUseHtmlMode(e.target.checked)}
                  />
                )}
              </div>
              
              {!useHtmlMode && !isFreesize && (
                <div>
                  <Button variant="outline-secondary" size="sm" onClick={loadDefaultTemplate} className="me-2">
                    Reset Mặc định
                  </Button>
                  <Button variant="outline-primary" size="sm" onClick={addColumn}>
                    + Thêm Cột
                  </Button>
                </div>
              )}
            </div>

            {isFreesize ? (
               <Form.Group className="mb-3">
               <Form.Label>Thông báo hiển thị cho khách hàng</Form.Label>
               <Form.Control
                 as="textarea"
                 rows={3}
                 value={freesizeContent}
                 onChange={(e) => setFreesizeContent(e.target.value)}
                 placeholder="Ví dụ: Sản phẩm này là Freesize, phù hợp với người dưới 60kg."
               />
               <Alert variant="info" className="mt-2 small">
                 Khi chọn chế độ này, bảng size sẽ không hiển thị. Thay vào đó, khách hàng sẽ thấy thông báo trên.
               </Alert>
             </Form.Group>
            ) : useHtmlMode ? (
              <Form.Group className="mb-3">
                <Form.Label>Nội dung (HTML)</Form.Label>
                <Form.Control
                  as="textarea"
                  rows={10}
                  value={htmlContent}
                  onChange={(e) => setHtmlContent(e.target.value)}
                  style={{ fontFamily: "monospace", fontSize: "0.9rem" }}
                />
                <div className="mt-2 p-2 border bg-light">
                  <small>Preview:</small>
                  <div dangerouslySetInnerHTML={{ __html: htmlContent }} />
                </div>
              </Form.Group>
            ) : (
              <div className="table-responsive">
                <table className="table table-bordered table-hover align-middle">
                  <thead className="table-light">
                    <tr>
                      {tableData.headers.map((header, index) => (
                        <th key={index} style={{ minWidth: "180px" }}>
                          <div className="d-flex gap-2 align-items-center">
                            <Form.Control
                              type="text"
                              value={header}
                              onChange={(e) => handleHeaderChange(index, e.target.value)}
                              className="fw-bold"
                            />
                            <Button
                              variant="outline-danger"
                              onClick={() => removeColumn(index)}
                              tabIndex="-1"
                              title="Xóa cột"
                              style={{ height: "38px", width: "38px", display: "flex", alignItems: "center", justifyContent: "center" }}
                            >
                              &times;
                            </Button>
                          </div>
                        </th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {tableData.rows.map((row, rowIndex) => (
                      <tr key={rowIndex}>
                        {row.map((cell, colIndex) => (
                          <td key={colIndex}>
                            <Form.Control
                              type="text"
                              value={cell}
                              onChange={(e) => handleRowChange(rowIndex, colIndex, e.target.value)}
                            />
                          </td>
                        ))}
                        <td style={{ width: "50px" }}>
                          <Button
                            variant="outline-danger"
                            size="sm"
                            onClick={() => removeRow(rowIndex)}
                            tabIndex="-1"
                            title="Xóa dòng"
                          >
                            &times;
                          </Button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
                <Button variant="outline-success" size="sm" onClick={addRow}>
                  + Thêm Dòng
                </Button>
              </div>
            )}
          </>
        )}
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide}>
          Đóng
        </Button>
        <Button
          variant="primary"
          onClick={handleSubmit}
          disabled={saving || loading}
        >
          {saving ? "Đang lưu..." : "Lưu thay đổi"}
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default AdminSizeChartModal;
