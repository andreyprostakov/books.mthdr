import React, { useContext } from 'react'
import { useSelector } from 'react-redux'
import { Badge } from 'react-bootstrap'
import PropTypes from 'prop-types'
import classNames from 'classnames'

import { selectTagRef, selectCategory } from 'store/tags/selectors'
import UrlStoreContext from 'store/urlStore/Context'

const TagBadge = (props) => {
  const { text, id, variant = 'light', renderPostfix, className, onClick, ...restProps } = props
  const label = `#${text}`
  const tagRef = useSelector(selectTagRef(id))
  const category = useSelector(selectCategory(tagRef?.categoryId))
  const { routes: { tagPagePath }, actions: { goto }, routesReady } = useContext(UrlStoreContext)

  if (!tagRef || !category) return null
  if (!routesReady) return null

  const classnames = classNames(['tag-container', `tag-category-${category.name}`, className])
  const clickHandler = onClick ? onClick : id => goto(tagPagePath(id))

  return (
    <Badge pill variant={ variant } className={ classnames } { ...restProps }>
      <a className='tag-name' href={ tagPagePath(id) } onClick={ (e) => { e.preventDefault(); clickHandler(id) } }>
        { label }
      </a>
      { renderPostfix && renderPostfix() }
    </Badge>
  )
}

TagBadge.propTypes = {
  text: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.number
  ]).isRequired,
  id: PropTypes.number,
  renderPostfix: PropTypes.func,
  variant: PropTypes.string
}

export default TagBadge
