db.getCollection('ssm2').aggregate([
    {"$group": {
        "_id": { "companyName": "$companyName"},
        "uniqueIds": { "$addToSet": "$_id"},
        "count": { "$sum": 1}
    }
},
{"$match": {
    "count": { "$gt": 1 }
}
}
])