const express = require('express');
const cors = require('cors');
const fs = require('fs-extra');
const { exec } = require('child_process');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json({ limit: '50mb' }));

// مسار التجميع
app.post('/api/compile', async (req, res) => {
    const { files } = req.body; // نستقبل شجرة الملفات
    const projectId = `project_${Date.now()}`;
    const projectPath = path.join(__dirname, 'projects', projectId);

    try {
        // 1. إنشاء مجلد فلاتر جديد
        await fs.ensureDir(projectPath);
        exec(`flutter create ${projectId} --platforms web`, { cwd: path.join(__dirname, 'projects') }, async (err) => {
            if (err) return res.status(500).json({ error: 'Failed to create project' });

            // 2. كتابة ملفاتك داخل المشروع
            for (const [filePath, content] of Object.entries(files)) {
                const fullPath = path.join(projectPath, filePath);
                await fs.ensureFile(fullPath);
                await fs.writeFile(fullPath, content);
            }

            // 3. بناء المشروع كويب
            exec(`flutter build web --web-renderer html`, { cwd: projectPath }, (buildErr) => {
                if (buildErr) return res.status(500).json({ error: 'Compilation failed', details: buildErr.message });

                // 4. تشغيل النتيجة
                app.use(`/preview/${projectId}`, express.static(path.join(projectPath, 'build/web')));
                res.json({ previewUrl: `/preview/${projectId}` });
            });
        });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Compiler running on port ${PORT}`));
