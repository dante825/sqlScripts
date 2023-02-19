db.getCollection('ssm').aggregate([
    {"$group": {
        "_id": { "companyName": "$companyName"},
        "uniqueIds": { "$addToSet": "$_id"},
        "rocs": {"$addToSet": "$registrationNo"},
        "count": { "$sum": 1}
    }
},
{"$match": {
    "count": { "$gt": 1 }
}
}
])