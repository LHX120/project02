<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>订单详情</title>
    <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
    <style>
        * { box-sizing: border-box; -webkit-tap-highlight-color: transparent; }
        body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, "PingFang SC", sans-serif; background: #edf6fb; color: #333; display: flex; flex-direction: column; min-height: 100vh; align-items: center; }
        
        /* 顶部蓝色导航栏 */
        .nav-bar { background: #2396e9; color: #fff; text-align: center; width: 100%; height: 64px; line-height: 64px; font-size: 21px; font-weight: 500; letter-spacing: 0.5px; }
        
        .container { width: 100%; max-width: 412px; padding: 0 24px; display: flex; flex-direction: column; align-items: center; flex: 1; }
        
        /* 数量提示 */
        .page-counter { color: #53b3f2; font-size: 17px; margin: 32px 0 24px 0; letter-spacing: 0.5px; }
        .page-counter span { font-weight: bold; }
        
        /* 大卡片主体 */
        .main-card { background: #f6faff; width: 100%; border-radius: 40px; padding: 36px 28px 28px 28px; display: flex; flex-direction: column; align-items: center; border: 1px solid rgba(255,255,255,0.6); box-shadow: 0 10px 30px rgba(35, 150, 233, 0.03); }
        
        /* 动态二维码红字 */
        .qr-tip { color: #ea6c47; font-size: 15px; font-weight: bold; margin-bottom: 18px; letter-spacing: 0.2px; }
        
        /* 二维码白色外框 */
        .qr-box { background: #fff; padding: 14px; border-radius: 16px; display: flex; justify-content: center; align-items: center; margin-bottom: 18px; border: 1px solid #e1eef6; }
        
        /* 票号数字 */
        .qr-num { color: #9daeb9; font-size: 18px; margin-bottom: 18px; font-family: "Helvetica Neue", Arial, sans-serif; letter-spacing: 0.3px; }
        
        /* 倒计时红字 */
        .countdown-text { color: #ea6c47; font-size: 15px; font-weight: bold; margin-bottom: 36px; }
        
        /* 详情列表 */
        .info-list { width: 100%; display: flex; flex-direction: column; gap: 22px; padding: 0 4px; margin-bottom: 32px; }
        .info-item { display: flex; align-items: flex-start; font-size: 17px; line-height: 1.5; }
        .info-label { color: #000000; font-weight: bold; width: 85px; flex-shrink: 0; }
        
        /* 关键：原版数据字色非常浅 */
        .info-value { color: #9daeb9; flex: 1; text-align: left; font-weight: 500; }
        .info-value.bold-black { color: #9daeb9; font-weight: 500; line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
        
        /* 温馨提示橘色框 */
        .tip-box { background: #fdf3ee; border-radius: 14px; padding: 16px 18px; width: 100%; }
        .tip-text { color: #ea6c47; font-size: 15px; font-weight: bold; margin: 0; text-align: justify; line-height: 1.6; letter-spacing: 0.2px; }
        
        /* 底部系统时间 */
        .bottom-time { color: #9daeb9; font-size: 17px; margin-top: auto; margin-bottom: 32px; font-family: "Helvetica Neue", Arial, sans-serif; letter-spacing: 0.2px; }
    </style>
</head>
<body>

    <div class="nav-bar">订单详情</div>

    <div class="container">
        <div class="page-counter"><span>1</span> 张，共 1 张</div>
        
        <div class="main-card">
            <div class="qr-tip">动态二维码，请勿截图使用</div>
            <div class="qr-box"><div id="qrcode"></div></div>
            <div class="qr-num">22025020213013778543341</div>
            <div class="countdown-text">将在 <span id="timer">7</span> 秒后刷新</div>
            
            <div class="info-list">
                <div class="info-item">
                    <div class="info-label">产品名称</div>
                    <div class="info-value bold-black">环全洲游览线（可直达毛泽东青年艺术雕塑站，含往返）</div>
                </div>
                <div class="info-item">
                    <div class="info-label">出游日期</div>
                    <div class="info-value" id="travel-date">2026-06-30</div>
                </div>
                <div class="info-item">
                    <div class="info-label">检票状态</div>
                    <div class="info-value">部分检票</div>
                </div>
            </div>
            
            <div class="tip-box">
                <p class="tip-text">温馨提示：可在毛泽东青年艺术雕塑站验票处或景区游客中心免费领取明信片一张。</p>
            </div>
        </div>
        
        <div class="bottom-time" id="system-time"></div>
    </div>

    <script>
        // 渲染深蓝色调二维码
        const qrcode = new QRCode(document.getElementById("qrcode"), {
            text: "22025020213013778543341",
            width: 145,
            height: 145,
            colorDark : "#084a86", 
            colorLight : "#ffffff",
            correctLevel : QRCode.CorrectLevel.H
        });

        // 倒计时
        let count = 7;
        const timerEl = document.getElementById("timer");
        setInterval(() => {
            count--;
            if (count < 0) count = 7;
            timerEl.innerText = count;
        }, 1000);

        // 动态同步时间与日期
        function updateTimes() {
            const now = new Date();
            const year = now.getFullYear();
            const month = String(now.getMonth() + 1).padStart(2, '0');
            const date = String(now.getDate()).padStart(2, '0');
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            const seconds = String(now.getSeconds()).padStart(2, '0');
            
            const todayStr = `${year}-${month}-${date}`;
            document.getElementById("travel-date").innerText = todayStr;
            document.getElementById("system-time").innerText = `${todayStr} ${hours}:${minutes}:${seconds}`;
        }
        updateTimes();
        setInterval(updateTimes, 1000);
    </script>
</body>
</html>
