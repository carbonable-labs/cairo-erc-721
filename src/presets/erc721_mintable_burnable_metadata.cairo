#[starknet::contract]
mod ERC721 {
    use starknet::{get_caller_address, ContractAddress};
    use cairo_erc_721::src5::interface::{ISRC5, ISRC5Legacy};
    use cairo_erc_721::src5::module::SRC5;
    use cairo_erc_721::module::ERC721;
    use cairo_erc_721::interface::{IERC721, IERC721Legacy, IERC721Mintable, IERC721Burnable};
    use cairo_erc_721::extensions::metadata::module::ERC721Metadata;
    use cairo_erc_721::extensions::metadata::interface::{IERC721Metadata, IERC721MetadataLegacy};

    #[storage]
    struct Storage {}

    #[constructor]
    fn constructor(ref self: ContractState, name: felt252, symbol: felt252) {
        self.initializer(name, symbol);
    }

    #[external(v0)]
    impl SRC5Impl of ISRC5<ContractState> {
        fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
            let unsafe_state = SRC5::unsafe_new_contract_state();
            SRC5::SRC5Impl::supports_interface(@unsafe_state, interface_id)
        }
    }

    #[external(v0)]
    impl SRC5LegacyImpl of ISRC5Legacy<ContractState> {
        fn supportsInterface(self: @ContractState, interfaceId: felt252) -> bool {
            self.supports_interface(interfaceId)
        }
    }

    #[external(v0)]
    impl ERC721Impl of IERC721<ContractState> {
        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            let unsafe_state = ERC721::unsafe_new_contract_state();
            ERC721::ERC721Impl::balance_of(@unsafe_state, account)
        }

        fn owner_of(self: @ContractState, token_id: u256) -> ContractAddress {
            let unsafe_state = ERC721::unsafe_new_contract_state();
            ERC721::ERC721Impl::owner_of(@unsafe_state, token_id)
        }

        fn get_approved(self: @ContractState, token_id: u256) -> ContractAddress {
            let unsafe_state = ERC721::unsafe_new_contract_state();
            ERC721::ERC721Impl::get_approved(@unsafe_state, token_id)
        }

        fn is_approved_for_all(
            self: @ContractState, owner: ContractAddress, operator: ContractAddress
        ) -> bool {
            let unsafe_state = ERC721::unsafe_new_contract_state();
            ERC721::ERC721Impl::is_approved_for_all(@unsafe_state, owner, operator)
        }

        fn approve(ref self: ContractState, to: ContractAddress, token_id: u256) {
            let mut unsafe_state = ERC721::unsafe_new_contract_state();
            ERC721::ERC721Impl::approve(ref unsafe_state, to, token_id)
        }

        fn set_approval_for_all(
            ref self: ContractState, operator: ContractAddress, approved: bool
        ) {
            let mut unsafe_state = ERC721::unsafe_new_contract_state();
            ERC721::ERC721Impl::set_approval_for_all(ref unsafe_state, operator, approved)
        }

        fn transfer_from(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256
        ) {
            let mut unsafe_state = ERC721::unsafe_new_contract_state();
            ERC721::ERC721Impl::transfer_from(ref unsafe_state, from, to, token_id)
        }

        fn safe_transfer_from(
            ref self: ContractState,
            from: ContractAddress,
            to: ContractAddress,
            token_id: u256,
            data: Span<felt252>
        ) {
            let mut unsafe_state = ERC721::unsafe_new_contract_state();
            ERC721::ERC721Impl::safe_transfer_from(ref unsafe_state, from, to, token_id, data)
        }
    }

    #[external(v0)]
    impl ERC721LegacyImpl of IERC721Legacy<ContractState> {
        fn balanceOf(self: @ContractState, account: ContractAddress) -> u256 {
            self.balance_of(account)
        }

        fn ownerOf(self: @ContractState, tokenId: u256) -> ContractAddress {
            self.owner_of(tokenId)
        }

        fn getApproved(self: @ContractState, tokenId: u256) -> ContractAddress {
            self.get_approved(tokenId)
        }

        fn isApprovedForAll(
            self: @ContractState, owner: ContractAddress, operator: ContractAddress
        ) -> bool {
            self.is_approved_for_all(owner, operator)
        }

        fn setApprovalForAll(ref self: ContractState, operator: ContractAddress, approved: bool) {
            self.set_approval_for_all(operator, approved)
        }

        fn transferFrom(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, tokenId: u256
        ) {
            self.transfer_from(from, to, tokenId)
        }

        fn safeTransferFrom(
            ref self: ContractState,
            from: ContractAddress,
            to: ContractAddress,
            tokenId: u256,
            data: Span<felt252>
        ) {
            self.safe_transfer_from(from, to, tokenId, data)
        }
    }

    #[external(v0)]
    impl ERC721MintableImpl of IERC721Mintable<ContractState> {
        fn mint(ref self: ContractState, to: ContractAddress, token_id: u256) {
            let mut unsafe_state = ERC721::unsafe_new_contract_state();
            ERC721::InternalImpl::_mint(ref unsafe_state, to, token_id)
        }
    }

    #[external(v0)]
    impl ERC721BurnableImpl of IERC721Burnable<ContractState> {
        fn burn(ref self: ContractState, token_id: u256) {
            // [Check] Ensure that the caller is the owner of the token
            let mut unsafe_state = ERC721::unsafe_new_contract_state();
            let owner = ERC721::InternalImpl::_owner_of(@unsafe_state, token_id);
            assert(get_caller_address() == owner, 'ERC721Burnable: wrong caller');
            // [Effect] Burn the token
            ERC721::InternalImpl::_burn(ref unsafe_state, token_id)
        }
    }

    #[external(v0)]
    impl ERC721MetadataImpl of IERC721Metadata<ContractState> {
        fn name(self: @ContractState) -> felt252 {
            let unsafe_state = ERC721Metadata::unsafe_new_contract_state();
            ERC721Metadata::ERC721MetadataImpl::name(@unsafe_state)
        }

        fn symbol(self: @ContractState) -> felt252 {
            let unsafe_state = ERC721Metadata::unsafe_new_contract_state();
            ERC721Metadata::ERC721MetadataImpl::symbol(@unsafe_state)
        }

        fn token_uri(self: @ContractState, token_id: u256) -> felt252 {
            let unsafe_state = ERC721Metadata::unsafe_new_contract_state();
            ERC721Metadata::ERC721MetadataImpl::token_uri(@unsafe_state, token_id)
        }
    }

    #[external(v0)]
    impl ERC721MetadataLegacyImpl of IERC721MetadataLegacy<ContractState> {
        fn tokenURI(self: @ContractState, tokenId: u256) -> felt252 {
            self.token_uri(tokenId)
        }
    }

    #[external(v0)]
    #[generate_trait]
    impl ExternalImpl of ExternalTrait {
        fn set_token_uri(self: @ContractState, token_id: u256, token_uri: felt252) {
            let mut unsafe_state = ERC721Metadata::unsafe_new_contract_state();
            ERC721Metadata::InternalImpl::_set_token_uri(ref unsafe_state, token_id, token_uri);
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn initializer(ref self: ContractState, name: felt252, symbol: felt252) {
            let mut unsafe_state = ERC721::unsafe_new_contract_state();
            ERC721::InternalImpl::initializer(ref unsafe_state);
            let mut unsafe_state = ERC721Metadata::unsafe_new_contract_state();
            ERC721Metadata::InternalImpl::initializer(ref unsafe_state, name, symbol);
        }
    }
}
