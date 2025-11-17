ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Indel Signature Browser"),
  dashboardSidebar(
    sidebarMenu(id = "tabs",
                menuItem("Koh ID89 Browser", tabName = "browser", icon = icon("dna")),
                menuItem("COSMIC ID83 Browser", tabName = "id83_browser", icon = icon("layer-group"))
    ),
    conditionalPanel(
      condition = "input.tabs == 'browser'",
      checkboxGroupInput(
        inputId = "show_types",
        label = "Select signature types:",
        choices = c("Koh89" = "ID89", "COSMIC83" = "ID83", "Koh476" = "ID476"),
        selected = c("ID89", "ID83", "ID476")
      )
    )
  ),
  dashboardBody(
    useShinyjs(),
    tags$style(HTML("
      /* 全局样式 */
      body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
      .content-wrapper { background-color: #f4f6f9; }
      
      /* 缩略图卡片 */
      .thumbnail-card {
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        padding: 20px;
        margin-bottom: 20px;
        transition: all 0.3s ease;
        text-align: center;
      }
      .thumbnail-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.15);
      }
      .thumbnail-card h4 {
        color: #2c3e50;
        font-weight: 600;
        margin-bottom: 15px;
        font-size: 16px;
      }
      .thumbnail-card img {
        border-radius: 8px;
        border: 2px solid #e8eaed;
        margin-bottom: 15px;
      }
      .thumbnail-card .btn {
        width: 100%;
        border-radius: 6px;
        font-weight: 500;
        padding: 10px;
        transition: all 0.3s ease;
      }
      
      /* 图片容器 */
      .img-container {
        background: white;
        border-radius: 12px;
        padding: 25px;
        margin-bottom: 25px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      }
      .img-section-title {
        font-size: 20px;
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 3px solid #3498db;
        display: inline-block;
      }
      .img-label {
        font-size: 13px;
        font-weight: 500;
        color: #7f8c8d;
        text-align: center;
        margin-bottom: 10px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }
      
      /* 图片样式 */
      .signature-img {
        border-radius: 8px;
        border: 2px solid #e8eaed;
        cursor: pointer;
        transition: all 0.3s ease;
        display: block;
        margin: 0 auto;
      }
      .signature-img:hover {
        border-color: #3498db;
        box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        transform: scale(1.02);
      }
      
      /* ID83 分组样式 */
      .id83-section {
        background: white;
        border-radius: 12px;
        padding: 30px;
        margin-bottom: 30px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      }
      .id83-label {
        font-size: 18px;
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 20px;
        padding-left: 15px;
        border-left: 4px solid #3498db;
      }
      .member-section {
        background: #f8f9fa;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 20px;
      }
      .member-name {
        font-weight: 600;
        font-size: 15px;
        color: #34495e;
        margin-bottom: 15px;
        padding: 8px 12px;
        background: white;
        border-radius: 6px;
        display: inline-block;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      }
      
      /* 按钮样式 */
      .btn-back {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        padding: 12px 24px;
        border-radius: 8px;
        font-weight: 500;
        transition: all 0.3s ease;
        box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
      }
      .btn-back:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
      }
      
      /* 响应式网格 */
      @media (max-width: 768px) {
        .thumbnail-card { margin-bottom: 15px; }
        .img-container { padding: 15px; }
      }
      
      /* Modal 样式优化 */
      .modal-content {
        border-radius: 12px;
        border: none;
      }
      .modal-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 12px 12px 0 0;
      }
    ")),
    tabItems(
      tabItem(tabName = "browser", uiOutput("signature_display")),
      tabItem(tabName = "id83_browser", uiOutput("id83_display"))
    )
  )
)