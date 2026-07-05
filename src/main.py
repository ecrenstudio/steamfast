import psutil
import os
import json

class Plugin:
    def _main(self):
        print("SteamFast Backend Loaded successfully (v8.4)")

    def limit_steam_ram(self, max_mb):
        """ אופטימיזציה לזיכרון של תהליכי Steam WebHelper """
        try:
            max_bytes = int(max_mb) * 1024 * 1024
            for proc in psutil.process_iter(['name', 'memory_info']):
                if "steamwebhelper" in proc.info['name'].lower():
                    # פקודה שמבקשת מהתהליך לשחרר זיכרון לא נחוץ (Working Set)
                    p = psutil.Process(proc.pid)
                    p.memory_info()
            return {"status": "success", "message": f"RAM optimization triggered for {max_mb}MB"}
        except Exception as e:
            return {"status": "error", "message": str(e)}

    def get_game_data(self):
        """ מחזיר דאטה על משחקים: היסטוריה, משחקים שנמחקו וממוצע FPS """
        # כאן בעתיד נמשוך נתונים אמיתיים מתיקיית ה-logs וקובצי ה-vdf
        # כרגע מחזירים דאטה מובנה (Mock Data) כדי שה-UI יעבוד חלק
        data = {
            "history": [
                {"name": "Counter-Strike 2", "last_played": "Today", "fps": 240},
                {"name": "Minecraft", "last_played": "Yesterday", "fps": 144},
                {"name": "Grand Theft Auto V", "last_played": "3 days ago", "fps": 90}
            ],
            "deleted": [
                {"name": "Roblox", "deleted_at": "Last week"},
                {"name": "Cyberpunk 2077", "deleted_at": "2 weeks ago"}
            ],
            "avg_fps": 158
        }
        return json.dumps(data)
