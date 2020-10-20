# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Python Development Workflow for Humans"
HOMEPAGE="https://github.com/pypa/pipenv https://pypi.org/project/pipenv/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-clone-0.2.5[${PYTHON_USEDEP}]
	>=dev-python/setuptools-40.0.0[${PYTHON_USEDEP}]
	>=dev-python/pip-9.0.1[${PYTHON_USEDEP}]
	>dev-python/requests-2.18.0[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-python/parver
	dev-python/invoke
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

# not completely packed
# requires networking
RESTRICT="test"

python_test() {
	py.test -v -v || die
}