from pymongo import MongoClient
from werkzeug.security import generate_password_hash
from datetime import datetime
url = "mongodb://Ajay:root@cluster0-shard-00-00.uxwf7.mongodb.net:27017,cluster0-shard-00-01.uxwf7.mongodb.net:27017,cluster0-shard-00-02.uxwf7.mongodb.net:27017/chatapp?ssl=true&replicaSet=atlas-47sly1-shard-0&authSource=admin&retryWrites=true&w=majority"

from user import User

client  = MongoClient(url)

db = client['chatapp']
collection = db['test']

room_collection = db['rooms']
room_members_collection = db['room_members']


def save_user(username , email , password):
    password_hash = generate_password_hash(password)
    collection.insert_one({"_id":username , "email":email , "password":password_hash})

#save_user('ajay' ,"magarajay538@gmail.com" , "test")

def get_user(username):
    user_data = collection.find_one({"_id":username})
    return User(user_data['_id'] , user_data['email'] , user_data['password']) if user_data else None

def save_room(room_name , created_by):
    room_id =  room_collection.insert_one({"name":room_name,'created_by':created_by , "created_at":datetime.now()}).inserted_id

    add_room_member(room_id , room_name , created_by , created_by , is_admin = True)
    return room_id 

def get_room(room_id):
    room_collection.find_one({"_id":ObjectId(room_id)})

def update_room(room_id , room_name):
    room_members_collection.update_one({"_id":ObjectId(room_id)},{"$set":{"name":room_name}})

def add_room_member(room_id , room_name , username , added_by , is_admin=False):
    room_members_collection.insert_one({"_id":{"room_id":ObjectId(room_id),"username":username},
                                     "room_name":room_name,"added_by":added_by,
                                    "added_at":datetime.now(),"is_room_admin":is_admin})

def add_room_members(room_id , room_name , usernames , added_by):
    room_members_collection.insert_many([{"_id":{"room_id":ObjectId(room_id),"username":username},
                                     "room_name":room_name,"added_by":added_by,
                                    "added_at":datetime.now(),"is_room_admin":False} for username in usernames])

def remove_room_members(room_id , usernames):
    room_members_collection.delete_many({"_id":{'$in':[{'room_id':room_id ,
                     "username":username} for username in usernames]}})

def get_room_members(room_id):
    room_members_collection.find({"_id.room_id":ObjectId(room_id)})

def get_rooms_for_user(username):
    room_members_collection.find({"_id.username":username})

def is_room_member(room_id ,username):
    room_members_collection.count_documents({'_id':{"room_id":ObjectId(room_id) , "username":username}})

def is_room_admin(room_id , username):
    room_members_collection.count_documents({"_id":{"room_id":ObjectId(room_id),
                                        "username":username},"is_room_admin":True})


