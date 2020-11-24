// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

library IterableMapping {
    struct Map {
        address[] key;
        mapping(address => uint256) value;
        mapping(address => uint256) indexOf;
        mapping(address => bool) inserted;
    }
    
    function get (Map storage map, address key) public view returns(uint256) {
        return map.value[key];
    }
    
    function getKeyAtIndex(Map storage map, uint256 index) public view returns (address) {
        return map.key[index];
    }
    
    function size (Map storage map) public view returns(uint256) {
        return map.key.length;
    }
    
    function set (Map storage map, address key, uint val) public {
        if (map.inserted[key]) {
            map.value[key] = val;
        } else {
            map.inserted[key] = true;
            map.value[key] = val;
            map.indexOf[key] = map.key.length;
            map.key.push(key);
        }
    }
    
    function remove (Map storage map, address key) public {
        if (!map.inserted[key]) {
            return;
        }
        delete map.inserted[key];
        delete map.value[key];
        uint256 index = map.indexOf[key];
        uint256 lastIndex = map.key.length - 1;
        address lastKey = map.key[lastIndex];
        map.indexOf[lastKey] = index;
        delete map.indexOf[key];
        map.key[index] = lastKey;
        map.key.pop();
    }
}