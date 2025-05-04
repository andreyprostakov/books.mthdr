import React from 'react'
import { Badge } from 'react-bootstrap'
import PropTypes from 'prop-types'
import classNames from 'classnames'

const TagBadge = (props) => {
  const { text, id, variant = 'light', renderPostfix, className, onClick, ...restProps } = props
  const label = `#${text}`

  const classnames = classNames(['tag-container', className])

  return (
    <Badge pill variant={ variant } className={ classnames } { ...restProps }>
      <a className='tag-name' onClick={ (e) => e.preventDefault() }>
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
