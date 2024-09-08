access(all) contract B {
    access(all) fun echo(_ s: String): String {
        return s
    }
}