// webapp/index.js

function injectSteamManageButton() {
    // מציאת סרגל הכלים העליון של סטים
    const menuContainer = document.querySelector('.steamdesktop_TitleBarControls_396es'); 
    
    if (menuContainer && !document.getElementById('steam-manage-btn')) {
        const btn = document.createElement('div');
        btn.id = 'steam-manage-btn';
        btn.style.cssText = "cursor: pointer; margin-left: 15px; color: #5c7e10; font-weight: bold; display: flex; align-items: center; font-size: 12px; font-family: sans-serif;";
        btn.innerText = 'steammeneage';
        
        btn.addEventListener('click', () => {
            openManageModal();
        });
        
        // הזרקה לתחילת הסרגל
        menuContainer.insertBefore(btn, menuContainer.firstChild);
    }
}

function openManageModal() {
    // יצירת חלון מודאלי פשוט מעל ה-UI של סטים
    if (document.getElementById('steam-manage-modal')) return;

    const modal = document.createElement('div');
    modal.id = 'steam-manage-modal';
    modal.style.cssText = "position: fixed; top: 10%; left: 25%; width: 50%; height: 60%; background: #171a21; color: #c7d5e0; border: 1px solid #3a3a3a; z-index: 9999; padding: 20px; font-family: Arial, sans-serif; box-shadow: 0 0 15px rgba(0,0,0,0.7);";
    
    modal.innerHTML = `
        <div style="display:flex; justify-content:space-between; border-bottom: 1px solid #3a3a3a; padding-bottom: 10px;">
            <h2 style="margin:0; color:#fff;">SteamFast Settings (v8.4)</h2>
            <button id="close-modal-btn" style="background:none; border:none; color:#fff; cursor:pointer; font-size:18px;">X</button>
        </div>
        <div style="margin-top: 20px;">
            <h3>RAM Management</h3>
            <label>Limit Steam RAM (MB): </label>
            <input type="number" id="ram-limit-input" value="1024" style="background:#2a475e; border:none; color:#fff; padding:5px; width:80px;">
            <button id="save-ram-btn" style="background:#5c7e10; border:none; color:#fff; padding:5px 10px; cursor:pointer; margin-left:10px;">Apply</button>
            
            <h3 style="margin-top:30px;">Game History & Statistics</h3>
            <div id="game-stats-content">Loading data from backend...</div>
        </div>
    `;

    document.body.appendChild(modal);

    // כפתור סגירה
    document.getElementById('close-modal-btn').addEventListener('click', () => {
        modal.remove();
    });

    // כפתור שמירת RAM שמפעיל את הפונקציה בפייתון
    document.getElementById('save-ram-btn').addEventListener('click', () => {
        const ramVal = document.getElementById('ram-limit-input').value;
        // קריאה חזרה לפייתון דרך המנגנון של Millennium
        window.Millennium.callBackendMethod("limit_steam_ram", ramVal).then(res => {
            alert("RAM optimization requested!");
        });
    });

    // משיכת נתוני משחקים מהפייתון
    window.Millennium.callBackendMethod("get_game_data").then(res => {
        const data = JSON.parse(res);
        let html = `<p><strong>Average FPS across all games:</strong> <span style="color:#66bb6a">${data.avg_fps} FPS</span></p>`;
        
        html += `<h4>Played Recently:</h4><ul>`;
        data.history.forEach(g => {
            html += `<li>${g.name} (${g.last_played}) - Avg: ${g.fps} FPS</li>`;
        });
        html += `</ul>`;

        html += `<h4>Deleted Games History:</h4><ul>`;
        data.deleted.forEach(g => {
            html += `<li style="color:#e57373">${g.name} - Deleted: ${g.deleted_at}</li>`;
        });
        html += `</ul>`;

        document.getElementById('game-stats-content').innerHTML = html;
    });
}

// לופ קצר לוודא שהאלמנטים של סטים נטענו לפני הזרקת הכפתור
const interval = setInterval(() => {
    injectSteamManageButton();
}, 1000);
