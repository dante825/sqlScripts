db.getCollection('nerEntity').aggregate([
    {$group: {
        _id: {entity: "$entity"},
        uniqueIds: {$addToSet: "$_id"},
        count: {$sum: 1}
        }
    },
    {$match: { 
        count: {"$gt": 1}
        }
    }
]);