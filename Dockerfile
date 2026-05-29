# 1. استخدم صورة فلاتر جاهزة تماماً (مُختبرة وموثوقة)
FROM ghcr.io/cirruslabs/flutter:stable

# 2. تغيير الصلاحيات للتعامل مع المجلدات
USER root
RUN apt-get update && apt-get install -y nodejs npm

# 3. إعداد مجلد العمل
WORKDIR /app

# 4. نقل ملفات مشروع الـ Node.js فقط (السيرفر)
COPY package*.json ./
RUN npm install
COPY . .

# 5. التبديل لصلاحيات المستخدم العادي
USER root
RUN chown -R flutter:flutter /app
USER flutter

# 6. تشغيل السيرفر
EXPOSE 3000
CMD ["npm", "start"]
