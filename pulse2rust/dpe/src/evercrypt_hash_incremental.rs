use super::evercrypt::EVERCRYPT;
use super::generated::evercrypt_gen;

pub fn hash_len(a: evercrypt_gen::Spec_Hash_Definitions_hash_alg) -> u32 {
    unsafe {
        return EVERCRYPT.EverCrypt_Hash_Incremental_hash_len(a);
    }
}

pub fn hash(
    a: evercrypt_gen::Spec_Hash_Definitions_hash_alg,
    output: &mut [u8],
    input: &mut [u8],
    p_input: (),
    v_input: (),
    input_len: u32,
) {
    unsafe {
        EVERCRYPT.EverCrypt_Hash_Incremental_hash(
            a,
            output.as_mut_ptr(),
            input.as_mut_ptr(),
            input_len,
        );
    }
}
