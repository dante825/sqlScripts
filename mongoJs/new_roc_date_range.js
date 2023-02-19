db.getCollection('ssm').find({"recordCreatedDate": {"$lt":ISODate("2020-07-20 12:43:42.805Z"), 
    "$gte": ISODate("2019-10-11 09:44:15.108Z")} }).sort({"recordCreatedDate": 1})