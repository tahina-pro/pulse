////
////
//// This file is generated by the Pulse2Rust tool
////
////

pub fn test(arr: &mut [u8]) -> () {
    let slice = arr;
    let _letpattern = slice.split_at_mut(2);
    match _letpattern {
        (mut s1, mut s2) => {
            let s2_ = {
                let res = &mut s2[1..4];
                res
            };
            let x = s2_[s1.len()];
            s1[1] = x;
            let _letpattern1 = s2.split_at_mut(2);
            match _letpattern1 {
                (mut s3, mut s4) => s3.copy_from_slice(s4),
            }
        }
    }
}

