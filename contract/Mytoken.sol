// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

//导入其他合约
import "./ConText.sol";

//is 继承 
contract Mytoken is ConText{
    // 1 代币信息

    // 代币名称 name
    string private _name;
    // 代币标识 symbol
    string private _symbol;
    // 代币小数位数 decimals
    uint8 private _decimals;
    // 代币总放行量 totalSupply
    uint256 private _totalSupply;
    // 代表数量 balance
    mapping(address => uint256) private _balance; 
    // 授权代币数量  allowance
    mapping(address => mapping(address => uint256)) private _allowance;

    // 2.初始化
    constructor (uint256 initialSupply){
       _name = "universe";
       _symbol = "UNIV";
       _decimals = 18;

       //初始化货币池
        _mint(_msgSender(), initialSupply * (10 ** uint256(_decimals)));
        //燃烧的方法
        
    }

    // 3.取值器

    //返回代币的名字 name()
    function name() public view returns (string memory){
        return _name;
    }


    //返回代币标识
     function symbol() public view returns (string memory){
        return  _symbol;
     }

    //返回代币的小数位数 decimals()
     function decimals() public view returns (uint8){
        return _decimals;
     }

     //返回代币总发行量
     function totalSupply() public view returns (uint256){
        return _totalSupply;
     }

     //返回账户拥有的代币数量
     function balanceOf(address account) public view returns (uint256){
        return _balance[account];
     }

     //返回授权代币数量 allowanceOf()
     function allowanceOf(address owner,address spender) public view returns(uint256){
        return  _allowance[owner][spender];
     }

     // 4. 函数 

     //代币转发
    function transfer(address _to, uint256 amount) public returns (bool){
        address owner = _msgSender();
        //实现转账
        _transfer(owner,_to,amount);
        return  true;
    }

    //授权代币转发
    function approve(address spender, uint256 amount) public returns (bool){
        //银行授权给我(银行要贷款给我)
        address owner = _msgSender();
        //owner 授权人
        //spender 被授权人
        //amount 借给我多少钱
        _approve(owner,spender,amount);
        return  true;
    }

    //授权代币转发
    function transferFrom(address from, address to, uint256 amount) public returns (bool){
        address owner = _msgSender();

        //更新授权账户信息
        _spendAllowance(from, owner, amount);

        //执行转账
        //from: 银行
        //to: 我自己，中介公司，买房人

        _transfer(from, to, amount);
        return  true;
    }


    // 5.事件
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    //6. 合约内部函数
    function _mint(address account, uint256 amount) internal {
       require(account != address(0),"ERC20: mint to the zero address");
        // 初始化货币数量
        _totalSupply += amount;
        //给某个账号注入起始资金
        _balance[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _transfer(address from,address to,uint256 amount) internal {
        require(from != address(0),"ERC20: transfer from the zero address");
        require(to != address(0),"ERC20: transfer to the zero address");
        require(_balance[from] >= amount,"ERC20: transfer amount exceeds balance");
        
        _balance[from] -= amount;
        _balance[to] += amount;
         
         emit Transfer(from,to,amount);
        
    }

    function _approve(address owner,address spender,uint256 amount) internal {
        require(owner != address(0),"ERC20: approve form the zero address");
        require(spender != address(0),"ERC20: spender form the zero address");
        //执行授权
        _allowance[owner][spender] = amount;
        emit Approval(owner, spender, amount );
    }

    function _spendAllowance(address owner,address spender,uint256 amount) internal {
        uint256 currentAllowance = allowanceOf(owner, spender);
        if(currentAllowance <= type(uint256).max){
            require(currentAllowance >= amount, "ERC20: transfer amount exceeds balance");
             _approve(owner,spender,currentAllowance - amount);
            
        }
    }

}