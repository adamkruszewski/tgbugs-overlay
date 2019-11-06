# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7} )
inherit distutils-r1

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/tgbugs/${PN}.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Python utilities for the Hypothes.is REST api and websocket interface"
HOMEPAGE="https://github.com/tgbugs/hyputils"

LICENSE="MIT"
SLOT="0"
IUSE="dev memex test zendesk"
REQUIRE_USE="
	python_targets_pypy3? ( !memex )
	test? ( memex )
"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/websockets[${PYTHON_USEDEP}]
	dev? (
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)
	memex? (
		dev-python/bleach[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/mistune[${PYTHON_USEDEP}]
		dev-python/psycopg:2[$(python_gen_usedep python3_{6,7})]
		$(python_gen_cond_dep 'dev-python/psycopg:2[${PYTHON_USEDEP}]' 'python3*')
		$(python_gen_cond_dep 'dev-python/psycopg2cffi[${PYTHON_USEDEP}]' 'pypy3')
		dev-python/slugify[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/webob[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/factory_boy[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
	zendesk? (
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/zdesk[${PYTHON_USEDEP}]
	)
"
RDEPEND="${DEPEND}"

src_prepare () {
	# replace package version to keep python quiet
	sed -i "s/__version__.\+$/__version__ = '9999.0.0'/" ${PN}/__init__.py
	default
}

python_test() {
	mkdir ${HOME}/.cache || die

	distutils_install_for_testing
	cd "${TEST_DIR}" || die
	cp -r "${S}/test" . || die
	cp "${S}/setup.cfg" . || die
	PYTHONWARNINGS=ignore pytest -v --color=yes || die "Tests fail with ${EPYTHON}"
}
