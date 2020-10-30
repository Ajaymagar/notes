from flask import Flask , request ,render_template , redirect , url_for
from flask_login import current_user 
from flask_socketio import SocketIO , send , join_room
from flask_login import LoginManager , login_user , logout_user , login_required
from db import get_user , save_user
from db import save_user , save_room , get_room , get_room_members , get_rooms_for_user , get_user
from db import add_room_members , add_room_member
from pymongo.errors import DuplicateKeyError
app = Flask(__name__)
app.secret_key = "mykey"
socketio =   SocketIO(app)

login_manager = LoginManager()
login_manager.login_view = 'login'
login_manager.init_app(app)
#app.config['SECRET_KEY'] = 'my screct'


@app.route('/')
def home():
    return render_template("index.html")


@app.route('/login' , methods=['GET','POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('home')) 
    
    message = ""
    if request.method == "POST":
        username = request.form.get('username')
        password_input = request.form.get("password")
        user = get_user(username)
        if user and user.check_password(password_input):
            login_user(user)
            return redirect(url_for('home'))
        else:
            message = "failed to Login"

    return render_template('login.html' , message=message)


@app.route('/signup',methods=["GET" , "POST"])
def signup():
    if current_user.is_authenticated:
        return redirect(url_for('home'))
    message = ''      
    if request.method == "POST":
        username = request.form.get('username')
        email = request.form.get('Email')
        password = request.form.get('password')
        try:
            save_user(username , email , password)
            return redirect(url_for('login'))
        except DuplicateKeyError:
            message = "user already Exits"
    return render_template('signup.html' , message=message)



@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('home'))
    

@app.route('/create-room',methods=["GET" , "POST"])
@login_required
def create_room():
    message = ""
    if request.method == "POST":
        room_name = request.form.get('room_name')
        usernames = [ username.strip() for username in request.form.get('members').split(',') ] 

        if len(room_name) and len(usernames):
            room_id = save_room(room_name ,current_user.username)

            if current_user.username in usernames:
                usernames.remove(current_user.username)
            add_room_members(room_id , room_name , usernames , current_user.username)
        else:
            message = "Failed to create room"
    return render_template('create_room.html' , message=message)


@app.route('/chat' ,methods=["GET","POST"])
@login_required
def chat():
    if request.method == "POST":

        username = request.form.get('username')
        room = request.form.get('room')

        if username and room:
            return render_template('chat.html' , username=username , room=room )
        else:
            return redirect(url_for('home'))


@socketio.on('join_user')
def handle_join_room_event(data):
    print(f"{data['username']} has joined the room {data['room']} ")
    join_room(data['room'])
    socketio.emit('join_room_announcement' , data)

@socketio.on('send_message')
def send_message(data):
    print(f'{data["username"]} has sent message to the room {data["room"]} {data["message"]}')

    socketio.emit('receive_message' , data , room=data['room'])

@login_manager.user_loader
def load_user(username):
    return get_user(username)
    

if __name__  == "__main__":
    socketio.run(app , debug=True)
    #app.run(debug=True) 