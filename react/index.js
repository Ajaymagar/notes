const redux  = require('redux')

const createStore = redux.createStore


const BUY_CAKE = "BUY_CAKE"

const buy_cake = ()=>{

    return {
        type: BUY_CAKE,
        info:'first redux action'
    }

}

const initalState = {

    numberofCakes : 10

}

const reducer = (state = initialState, action) =>{
    switch(action.type){
        case BUY_CAKE:
                return{
                    numberofCakes = state.numberofCakes - 1 
                }
        default : return state 
    }
}


 const store = createStore(reducer)