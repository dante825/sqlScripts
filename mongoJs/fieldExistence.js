db.getCollection('webCrawler').find({"sourceLanguage":"en", "nerFlag": { $exists: false } })