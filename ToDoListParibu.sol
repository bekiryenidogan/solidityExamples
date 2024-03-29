// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TodoList {
    
    //Todo Object
    struct Todo{
        string text;
        bool completed;
    }

    Todo [] public  todos;

    //Create new task
    function create(string calldata _text) external {
        todos.push(Todo({
            text:_text,
            completed:false
        }));
    }

    //task update
    function update(uint256 _index,string calldata _text) external {
        todos[_index].text = _text;
    }

    // get task
    function get(uint _index) external view returns(string memory,bool) {
        Todo memory todo = todos[_index];
        return (todo.text,todo.completed);
    }

    // complete task

    function toggleCompleted (uint _index) external {
        todos[_index].completed = !todos[_index].completed;
    }
}