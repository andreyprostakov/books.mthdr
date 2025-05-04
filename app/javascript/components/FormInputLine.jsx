import React, { useEffect, useRef } from 'react'
import { Col, Form, Row } from 'react-bootstrap'
import PropTypes from 'prop-types'

const FormInputLine = (props) => {
  const { controlId, label, value, autoFocus = false, ...other } = props
  const errors = props.errors || []
  const ref = useRef(null)
  const withLabel = !!label

  useEffect(() => autoFocus && ref.current.focus(), [])

  return (
    <Form.Group as={ Row } controlId={ controlId }>
      { withLabel &&
        <Form.Label column sm={ 3 }>{ label }</Form.Label>
      }
      <Col sm={ withLabel ? 9 : 12 }>
        <Form.Control type='text' defaultValue={ value } isInvalid={ errors.length > 0 } ref={ ref }
          { ...{ ...other } }
          autoComplete='off'
        />
        <Form.Control.Feedback type='invalid' tooltip>
          { errors.join('; ') }
        </Form.Control.Feedback>
      </Col>
    </Form.Group>
  )
}

FormInputLine.propTypes = {
  controlId: PropTypes.string.isRequired,
  label: PropTypes.string,
  value: PropTypes.any,
  errors: PropTypes.array,
  onChange: PropTypes.func
}

export default FormInputLine
